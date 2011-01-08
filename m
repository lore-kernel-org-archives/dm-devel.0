From: Mikulas Patocka <mpatocka@redhat.com>
Subject: kobject_put vs module unload
Date: Fri, 7 Jan 2011 22:42:22 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1101072234040.382@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I'm looking at some kobject problem in device mapper and I came across 
this problem:

According to kobject interface specification, If we embed a kobject into 
the device structure, we shouldn't free the device structure when the 
device is unloaded, but we should register a "release" callback in 
kobj_type that will actually free the device structure.

What happens in this scenario?:

1) someone references a device kobject
2) the device is unloaded (but the device structure is still in memory 
because of that reference)
3) the driver module is unloaded
4) the reference obtained at point 1) is dropped, kobject reference count 
reaches zero and the release callback is called. But that callback points 
to an unloaded module and causes a crash.

How is it solved? Am I missing something?

Mikulas
