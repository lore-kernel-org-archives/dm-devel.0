From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: dm-cache refusing to come up again after a crash
Date: Fri, 6 Dec 2013 20:16:05 +0100
Message-ID: <20131206191605.GA9700@samfundet.no>
References: <20131206154914.GE25206@samfundet.no>
	<20131206175712.GD23496@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131206175712.GD23496@debian>
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

On Fri, Dec 06, 2013 at 05:57:13PM +0000, Joe Thornber wrote:
> Yep, grab:
> 
> https://github.com/jthornber/thin-provisioning-tools
> 
> build, and then try cache_check on it (which should tell you what's
> wrong).  Other programs to play with are cache_dump, cache_restore and
> cache_repair.

Well, first of all, it doesn't compile, since you use typename outside of
templates :-) Fixing that is easy, though. But afterwards:

root@ubuntu:~/thin-provisioning-tools# ./cache_check /dev/md1
examining superblock
  superblock is corrupt
    bad checksum in superblock

So where do I want to go from there? cache_dump doesn't want to play with the
superblock because the checksum is bad... do I want cache_repair, then? Do I
want to take a backup of anything first?

/* Steinar */
-- 
Homepage: http://www.sesse.net/
