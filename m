From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] Just inform and dont warn when DM_DEV_REMOVE
 is	tried on a open device
Date: Tue, 20 Apr 2010 10:00:18 +0200
Message-ID: <4BCD5F12.7080107@redhat.com>
References: <201004201246.58828.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201004201246.58828.knikanth@suse.de>
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
Cc: Nikanth Karthikesan <knikanth@suse.de>, Alasdair G Kergon <agk@redhat.com>, Stefan Assmann <s.assmann@gmx.de>
List-Id: dm-devel.ids

On 04/20/2010 09:16 AM, Nikanth Karthikesan wrote:
> Dont warn when DM_DEV_REMOVE ioctl is tried on a open device.
> 
> On openSUSE when cryptsetup and udev interact, cryptsetup sometimes tries to
> remove a dm device currently opened by blkid, which is not a serious issue to
> print a kernel warning. The application should retry if -EBUSY is returned. So
> let us make it an informational message instead.

> -		DMWARN("unable to remove open device %s", hc->name);
> +		DMINFO("unable to remove open device %s", hc->name);

NAK.

Firstly, it is security problem if someone from udev rules tries to open
temporary-cryptsetup device, it contains only private key material.

Secondly, it must be solved on application level and not paper kernel using
patches which hides errors.

FYI there is already patch in upstream cryptsetup which uses udev cookie mechanism.
It still cannot solve artificial change events (which causes scan from rules randomly),
but should help here. (will be in cryptsetup 1.1.1)

Milan
