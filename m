From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [RFC] writeboost: rename "migration" to "writeback"
Date: Fri, 18 Jul 2014 10:00:58 +0900
Message-ID: <20140718100058.3fe6431ba0e083907885ea0d@gmail.com>
References: <87fvi70xyv.wl%satoru.takeuchi@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87fvi70xyv.wl%satoru.takeuchi@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, ejt@redhat.com, ruby.wktk@gmail.com
List-Id: dm-devel.ids

Hi, Satoru,

> How about re-renaming "migration" to more straightforward "writeback"?
> If you agree with this idea, I'll write a patch to fix it for kernel and
> device-mapper-test-suite.
I really appreciate that you will do this work.
Please run dmts after you finish renaming.

- Akira

On Sat, 12 Jul 2014 17:42:48 +0900
Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:

> Hi Akira, Joe, and all.
> 
> Recently I've used dm-writeboost a bit. I have an opinion about the
> naming of migration. Writeboost call writeback from cache device to backing
> device "migration" as Akira said in the following his document.
> 
> https://github.com/akiradeveloper/dm-writeboost/blob/develop/doc/writeboost.txt
> ===
> ...
> (2) Migrate Daemon
> This daemon writes back the dirty data on the cache device to the backing
> device. Writeboost calls writeback "Migration".
> ...
> ===
> 
> However, I consier "writeback" is far straightforward word than "migration"
> here for most people. Since such renaming makes the usability (migration is
> visible to user) and code readability, it should be avoided without special
> reason.
> 
> How about re-renaming "migration" to more straightforward "writeback"?
> If you agree with this idea, I'll write a patch to fix it for kernel and
> device-mapper-test-suite.
> 
> Thanks,
> Satoru
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
