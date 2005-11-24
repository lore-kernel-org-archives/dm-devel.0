From: Bret Towe <magnade@gmail.com>
Subject: Re: lvm/nfs crash
Date: Wed, 23 Nov 2005 20:52:40 -0800
Message-ID: <dda83e780511232052y3430248bv8020d36b54e9713f@mail.gmail.com>
References: <dda83e780511231808j64878ed0tc629db72cd94b164@mail.gmail.com>
	 <20051123182443.67e971cc.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751338AbVKXEwl@vger.kernel.org>
In-Reply-To: <20051123182443.67e971cc.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/23/05, Andrew Morton <akpm@osdl.org> wrote:
> Bret Towe <magnade@gmail.com> wrote:
> >
> > while doing a pvmove to get some data off of a drive that was starting to fail
> > i did a refresh on a nfs mount from a client and the server
> > doing this pvmove got the following crash in dmesg
> > and it happened pvmove didnt make any progress any more
> > after a reboot so i could try resuming pvmove it would crash on
> > fsck of one of the lvm partitons i finally got it to boot correctly after
> > running a livecd resuming the pvmove from there without even
> > trying to fsck
> >
> > the kernel that did this orignally i had named 2.6.14-git11.5
> > which for me means i synced to the git tree before the -git12 snapshot
> > had been made  i also booted back to 2.6.13.3 to see if it worked
> > but it gave similiar crash i forgot to take a picture of ether of those
> > crashs at boot but solving this other crash would prob prevent
> > the other from happening
> >
> > and no before you ask i do not intend to repeat it :)
> > hopefully somethin can be made of this
> >
>
> Are you using 4k stacks or 8k?

CONFIG_4KSTACKS=y

so says the .config
