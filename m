From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache refusing to come up again after a crash
Date: Mon, 9 Dec 2013 10:31:04 +0000
Message-ID: <20131209103103.GC26971@debian>
References: <20131206154914.GE25206@samfundet.no>
	<20131206175712.GD23496@debian>
	<20131206191605.GA9700@samfundet.no>
	<20131206193541.GC9700@samfundet.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131206193541.GC9700@samfundet.no>
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

On Fri, Dec 06, 2013 at 08:35:41PM +0100, Steinar H. Gunderson wrote:
> On Fri, Dec 06, 2013 at 08:16:05PM +0100, Steinar H. Gunderson wrote:
> > Well, first of all, it doesn't compile, since you use typename outside of
> > templates :-) Fixing that is easy, though. But afterwards:
> > 
> > root@ubuntu:~/thin-provisioning-tools# ./cache_check /dev/md1
> > examining superblock
> >   superblock is corrupt
> >     bad checksum in superblock
> 
> Sorry, wrong device:
> 
> root@ubuntu:~/thin-provisioning-tools# ./cache_check /dev/cache/metadata 
> examining superblock
> examining mapping array
> no hint array present
> examining discard bitset
> root@ubuntu:~/thin-provisioning-tools# echo $?
> 0
> 
> Does that mean it ought to have worked better? :-)

Yes, this is good news.  The damage is probably in the space maps
which get completely regenerated during a restore/repair.

I see from a later mail that you're having another issue with the
tools.  I wonder if you could email me off list, and we'll work out
how I can get a copy of your metadata.

- Joe
