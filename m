From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [Kernel PATCH] emit change on devmapper devices
Date: Mon, 12 Nov 2007 16:20:52 -0500
Message-ID: <4738C3B4.8020504@cfl.rr.com>
References: <1194454207.6273.5.camel@wing-commander>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1194454207.6273.5.camel@wing-commander>
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
Cc: linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids

Scott James Remnant wrote:
> Hi guys,
> 
> I've had this patch sitting on my disk for a few months, and haven't
> done anything more than test it.  Before I stuff it into git, and send
> it to the kernel, would you guys have a look over it and see whether
> it's technically correct.
> 
> The patch simply causes a kobject "change" event to be emitted on
> devmapper block devices when they are renamed.

When they are renamed?  Don't you want a change event when you modify 
the table?
