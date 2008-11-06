From: Adam Hamsik <haaaad@gmail.com>
Subject: Re: Re: Source code repository changes
Date: Thu, 6 Nov 2008 15:15:02 +0100
Message-ID: <625C3C1C-82F7-4E52-BDE0-913FC447B1A7@gmail.com>
References: <20081105005507.GH14593@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081105005507.GH14593@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


On Nov,Wednesday 5 2008, at 1:55 AM, Alasdair G Kergon wrote:

> OK - I'd like packagers to start testing what is currently in LVM2  
> CVS and
> report any problems with sets of configuration options / make  
> targets actually
> required.
>
> Once the Fedora 11 tree opens (expected end of this week) I shall  
> make the
> first tarball release and use this code.


I want to ask if it would be possible to merge NetBSD patches. During  
this summer I have
ported libdevmapper/lvm2tools to NetBSD. Currently I can use lvm with  
lvm2tools on NetBSD
with out any problems. Only needed changes for libdevmapper was  
addition of 3 files(netbsd-dm.h
libdm-nbsd-iface.c libdm_netbsd.c to ioctl code). In lvm2tools I have  
added 2 files and written
some small patches to support BSD raw devices. I can provide patches  
if merge would be possible.

Regards

Adam.
