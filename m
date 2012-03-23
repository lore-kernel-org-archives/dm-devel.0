From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm-bufio
Date: Fri, 23 Mar 2012 12:10:23 +0100
Message-ID: <4F6C5A1F.1000103@redhat.com>
References: <CALLzPKZyOc+_Pjht8uR6AJOBsMFXQN=y5QWvD0_OZFaYJpvRig@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALLzPKZyOc+_Pjht8uR6AJOBsMFXQN=y5QWvD0_OZFaYJpvRig@mail.gmail.com>
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
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, mpatocka@redhat.com
List-Id: dm-devel.ids

Dne 23.3.2012 12:01, Kasatkin, Dmitry napsal(a):
> Hello,
> 
> When using dm-bufio and dm-io in general, how to ensure that all dirty
> buffers are written to the storage when machine reboots?
> suspend hooks could be used, but they are not called on reboot, only
> when suspending/removing the target...
> 

You mean you reboot without running  'sync' command?

And yes - on reboot you should properly unmount devices - so you should
see removal of target on your shutdown sequence -  I believe Fedora currently
tries to support switch to some shutdown ramdisk, so all filesystem and
devices might be properly unmounted and destroyed.

Zdenek
