From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: dm-writeboost v1.0.0 released
Date: Wed, 13 May 2015 19:38:10 +0900
Message-ID: <55532992.1020103@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I will announce the release of log-structured caching target dm-writeboost v1.0.0 as an out-of-tree driver.
For a long time, I was trying to persuade dm maintainers to merge this driver
but I finally gave up and decided to maintain by myself as an out-of-tree driver.

https://github.com/akiradeveloper/dm-writeboost

Since the rejected v3 patch for the staging subtree on January,
some changes and fixes have been applied to the driver code.
It's now easy to install this driver through dkms and supported to run on kernel from 3.10 to the latest.

To know about dm-writeboost, first read this slide
https://docs.google.com/presentation/d/1v-L8Ma138o7jNBFqRl0epyc1Lji3XhUH1RGj8p7DVe8/edit?usp=sharing

If you want to know deeper, read this slide
https://docs.google.com/presentation/d/1mDh5ct3OR-eRxBbci3LQgaTvUFx9WTLw-kkBxNBeTD8/edit?usp=sharing

Any user feedback is welcome.

Thank you for reading,
- Akira
