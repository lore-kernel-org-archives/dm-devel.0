From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: software raid & intent bitmap on other device
Date: Thu, 30 May 2013 18:02:36 -0500
Message-ID: <4D23777D-842E-4AEB-A79C-71F3C32C869D@redhat.com>
References: <20130530102525.GM10944@belle.intranet.vanheusden.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130530102525.GM10944@belle.intranet.vanheusden.com>
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


On May 30, 2013, at 5:25 AM, folkert wrote:

> Hi,
> 
> I'm going to setup a software raid-1 and would like to improve its
> performance by storing things like the write intent bitmap (and fs
> journals but that's not relevant here) on a seperate disk. In this case
> and SSD.

"mirror" segment type or "raid1" segment type?

You can do this via device-mapper (i.e. 'dmsetup') for both target types.  However, if you are using LVM, you can only have separate placement of the log device with the "mirror" segment type.

> I was wondering: as SSDs frequently seem to die, what happens with the
> raid? Things will probably oops, panic and crash but after the reboot:
> will it refuse to come up? Or will it come up and just to a complete
> resync?

If you are using "mirror" segment type via LVM, it will simply convert to using an in-memory log.  However, that means that the entire mirror will need to be sync'ed if you deactivate the LV or reboot the machine.  (You could always replace the log on a different device though.)

So, there are a few options, but I'd be interested to see if there is any real benefit to putting the log on an SSD.

 brassow
