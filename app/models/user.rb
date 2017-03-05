class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save :downcase_email
	# before_create :create_activation_digest

	has_many :microposts, dependent: :destroy
	has_many :active_relationships, class_name: "Relationship",
																	foreign_key: "follower_id",
																	dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
																	foreign_key: "followed_id",
																	dependent: :destroy

	#following is a array, it consists of the values of :followed in the database
	has_many :following, through: :active_relationships, source: :followed
	#下面这条的source 可以省略，因为rails会根据前面的followers找到follower
	has_many :followers, through: :passive_relationships, source: :follower

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end



	before_save {self.email = email.downcase}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, presence: true, length:{maximum: 50}
	validates :email, presence: true , length:{maximum: 255},
									format: { with: VALID_EMAIL_REGEX  },
									uniqueness: { case_sensitive: false}
	# 在数据库中的password_digest列存储安全的密码哈希值;
    # 获得一对“虚拟属性”,17password和password_confirmation,而且创建用户对象时会执行存在性验证
    #和匹配验证;
    #获得authenticate方法,如果密码正确,返回对应的用户对象,否则返回false。

	has_secure_password

	validates :password, presence: true, length:{minimum: 6}, allow_nil: true

		def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
			                                                      BCrypt::Engine.cost
			BCrypt::Password.create(string, cost: cost)
		end

		def User.new_token
			SecureRandom.urlsafe_base64
		end

#第一个参数是一个符号，第二个参数是token
		def authenticated?(attribute, token)
			digest = self.send("#{attribute}_digest")
			return false if digest.nil?
			BCrypt::Password.new(digest).is_password?(token)
		end

		def forget
			update_attribute(:remember_digest,nil)
		end



		def send_activation_email
			UserMailer.account_activation(self).deliver_now
		end

		def create_reset_digest
			self.reset_token = User.new_token
			update_attribute(:reset_digest, User.digest(reset_token))
			update_attribute(:reset_sentat, Time.zone.now)
		end

		def send_password_reset_email
			UserMailer.password_reset(self).deliver_now
		end

		def password_reset_expired?
			reset_sentat < 2.hours.ago
		end


	def feed
        following_ids = "SELECT followed_id FROM relationships
                         WHERE  follower_id = :user_id"
		Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
	end

		def follow(other_user)
			self.active_relationships.create(followed_id: other_user.id)
		end

		def unfollow(other_user)
			active_relationships.find_by(followed_id: other_user.id).destroy
		end

		def following?(other_user)
			following.include?(other_user)
		end





		private

			def downcase_email
				self.email = email.downcase
			end



end
