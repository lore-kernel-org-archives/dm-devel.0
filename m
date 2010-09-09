From: Ryan Harper <ryanh@us.ibm.com>
Subject: Re: [REGRESSION][BISECTED] virtio-blk serial attribute causes guest to hang [Was: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support for request-based dm]
Date: Thu, 9 Sep 2010 11:03:24 -0500
Message-ID: <20100909160324.GJ30086@us.ibm.com>
References: <20100902032246.GA31484@redhat.com> <20100909152658.GA8118@redhat.com> <20100909154442.GI30086@us.ibm.com> <20100909155726.GA9081@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100909155726.GA9081@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ryan Harper <ryanh@us.ibm.com>, Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, john.cooper@redhat.com, rusty@rustcorp.com.au, hch@infradead.org, kvm@vger.kernel.org
List-Id: dm-devel.ids

* Mike Snitzer <snitzer@redhat.com> [2010-09-09 10:58]:
> On Thu, Sep 09 2010 at 11:44am -0400,
> Ryan Harper <ryanh@us.ibm.com> wrote:
> 
> > * Mike Snitzer <snitzer@redhat.com> [2010-09-09 10:29]:
> > > On Wed, Sep 01 2010 at 11:22pm -0400,
> > > Mike Snitzer <snitzer@redhat.com> wrote:
> > > 
> > > > On Wed, Sep 01 2010 at  2:59pm -0400,
> > > > Mike Snitzer <snitzer@redhat.com> wrote:
> > > > 
> > > > > My hope was that the request-based deadlock I'm seeing would disappear
> > > > > if that relaxed ordering patch wasn't applied.  Unfortunately, I still
> > > > > see the hang.
> > > > 
> > > > Turns out I can reproduce the hang on a stock 2.6.36-rc3 (without _any_
> > > > FLUSH+FUA patches)!
> > > > 
> > > > I'll try to pin-point the root cause but I think my test is somehow
> > > > exposing a bug in my virt setup.
> > > 
> > > [my virt setup == single kvm guest (RHEL6) with F13 host]
> > 
> > What's your kvm guest command line?
> 
> I assume you mean qemu-kvm commandline:
> 
> /usr/bin/qemu-kvm -S -M pc-0.11 -enable-kvm -m 2048 -smp 1,sockets=1,cores=1,threads=1 -name rhel6.x86_64 -uuid 9129e4e4-15d3-00e2-e9de-2c28a29feb52 -nodefaults -chardev socket,id=monitor,path=/var/lib/libvirt/qemu/rhel6.x86_64.monitor,server,nowait -mon chardev=monitor,mode=readline -rtc base=utc -boot cd -drive file=/var/lib/libvirt/images/rhel6.x86_64.img,if=none,id=drive-virtio-disk0,boot=on,format=raw,cache=none -device virtio-blk-pci,bus=pci.0,addr=0x4,drive=drive-virtio-disk0,id=virtio-disk0 -drive file=/var/lib/libvirt/images/boot.iso,if=none,media=cdrom,id=drive-ide0-1-0,readonly=on,format=raw -device ide-drive,bus=ide.1,unit=0,drive=drive-ide0-1-0,id=ide0-1-0 -device virtio-net-pci,vlan=0,id=net0,mac=54:52:00:70:e8:23,bus=pci.0,addr=0x6 -net tap,fd=49,vlan=0,name=hostnet0 -char
 dev pty,id=serial0 -device isa-serial,chardev=serial0 -usb -device usb-tablet,id=input0 -vnc 127.0.0.1:0 -vga cirrus -device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x3
> 
> I'm using virtio-blk w/ cache=none for the root device.  virtio-blk
> isn't used for any other devices in the guest.

And you don't have any other disks in the guest (I see just the root and
the cdrom), the lv stuff is happening against some sort of dummy target?


> 
> Here is the guest's kernel commandline (not that it is interesting):
> ro root=UUID=e0236db2-5a38-4d48-8bf5-55675671dee6 console=ttyS0 rhgb quiet SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us rd_plytheme=charge crashkernel=auto
> 
> > And the guest is using stock RHEL6 kernel?
> 
> No, the guest is using the upstream kernel.org kernel.  Hence my report
> of an upstream regression.  The guest is using RHEL6 userspace (udev in
> all its glory, etc).


> 
> > What KVM userspace are you using on the host?  What comes with
> > F13 or some updated version?
> 
> Just what comes with F13.
> 
> Mike

-- 
Ryan Harper
Software Engineer; Linux Technology Center
IBM Corp., Austin, Tx
ryanh@us.ibm.com
