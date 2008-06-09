From: malahal@us.ibm.com
Subject: Re: Questin about device mapper, Debian and devices
Date: Mon, 9 Jun 2008 07:53:18 -0700
Message-ID: <20080609145318.GA26029@us.ibm.com>
References: <454237550806090308j20a29e58w7dc22b89ce055e5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <454237550806090308j20a29e58w7dc22b89ce055e5@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

January Weiner [january@uni-muenster.de] wrote:
> Hello,
> 
> I am running a server with Debian stable. After a recent automatic
> update and an unrelated reboot suddenly I could not mount some of my
> hard disks any more. For example,
> 
> mount /dev/sda1 /mnt
> 
> gave me
> 
> mount: /dev/sda1 already mounted or /mnt busy
> 
> It took me quite a while to figure out that it is the device mapper
> that makes /dev/sda1 busy. For whatever reason, there are now the
> files /dev/dm-0, /dev/dm-1 and /dev/dm-2 that correspond to /dev/sda,
> /dev/sda1 and /dev/sda2. I assume they have been created by the dev
> mapper. The server has been running for ages, has a relatively complex
> setup and has been through a number of configurations. However, I
> never really used dev mapper.
> 
> My questions are as follows:
> 
> 1) does dev mapper somehow automatically gets hold of my /dev/sda, or
> is there a configuration file somewhere (maybe a stale configuration
> that got used after the update? I used to have an lvm, but I got rid
> of it. Never on purpose used multipath-tools or dm-crypt). My
> suspicion is that it is due to multipath, as multipath -l shows
> 
> 3600d0230006c1c550bdc214a99d0c000dm-0 Transtec,PV610F16R1B
> [size=2.7T][features=0][hwhandler=0]
> \_ round-robin 0 [prio=0][active]
>  \_ 3:0:0:0 sda 8:0   [active][undef]
> 
> ...but I never told multipath to do that! Running multipath -v 3 -l
> shows that there are some disks that are "blacklisted":
> 
> cciss!c0d0: blacklisted
> cciss!c0d1: blacklisted
> dm-0: blacklisted
> dm-1: blacklisted
> dm-2: blacklisted
> fd0: blacklisted
> ...
> 
> Are they blacklisted automatically or is there a way to do it manually?

Remove /etc/multipath.conf file if you have. Same file can be used to
blacklist if you want to apply multipath to exclude few devices.
