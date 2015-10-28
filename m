From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/6] dm-stripe: Fix error message
Date: Wed, 28 Oct 2015 18:00:57 -0400
Message-ID: <20151028220055.GA22827@redhat.com>
References: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
	<1445974740-8362-6-git-send-email-kusumi.tomohiro@gmail.com>
	<20151028195128.GA22241@redhat.com>
	<CAHndrBn06ih=6atGBcC7TjoFEWd0y=9WPu6GBygFE06y6Q=j7w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHndrBn06ih=6atGBcC7TjoFEWd0y=9WPu6GBygFE06y6Q=j7w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 28 2015 at  4:40pm -0400,
Tomohiro Kusumi <kusumi.tomohiro@gmail.com> wrote:

> hi, thanks for your reply.
> 
> I understand what you mean, but that's the reason.
> I happened to use something like below via dmsetup
> 
> --table '0 100 striped 2 4 /dev/xxx 0 /dev/yyy 0'
> 
> and hit this message which is not obvious as long as it says "Target
> length".
> Users have no idea 50/4 was what was really done in kernel space.

You're allowing a very literal look at the code to cloud your perception
of the error and concluding that it is misleading/incorrect.

Just because the code does math in a certain order doesn't change the
fact that the error message is still correct (if/when it is reported).
