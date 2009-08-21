From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Issue with setting uid/gid/mode in multipath.conf
Date: Fri, 21 Aug 2009 10:14:27 +0100
Message-ID: <1250846067.2720.194.camel@breeves.fab.redhat.com>
References: <1250796306.746.6.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1250796306.746.6.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2009-08-20 at 12:25 -0700, Chandra Seetharaman wrote:
> After adding this, I do a "multipath -F" following by "multipath" (or
> multipath -F followed by /etc/init.d/multipathd restart), I see the
> attributes are set properly on the device.
> 
> I reboot the system, the device is created (under /dev/mapper) but
> attributes are not set as defined in the multipath.conf file.
> 
> Have you seen this issue ? 
> 
> I am using RHEL 5.3 ga version (kernel and tools).
> 
> I am not booting from a multipath device (IOW, there is no
> multipath.conf in initrd).

Hi Chandra,

I've seen problems with this as well. In my testing the setting of the
UID/GID is unreliable - in around one of five runs the uid/gid take the
default instead of the configured value.

I'm intending to open a Red Hat BZ for this problem today.

Regards,
Bryn.
