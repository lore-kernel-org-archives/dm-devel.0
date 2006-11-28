From: Luca Berra <bluca@comedia.it>
Subject: Re: Where did /dev/dm-X go?
Date: Tue, 28 Nov 2006 11:31:01 +0100
Message-ID: <20061128103101.GB27595@percy.comedia.it>
References: <20061126210911.GA8818@imp.flyn.org>
	<20061127203037.GA27595@percy.comedia.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061127203037.GA27595@percy.comedia.it>
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

On Mon, Nov 27, 2006 at 09:30:37PM +0100, Luca Berra wrote:
>On Sun, Nov 26, 2006 at 03:09:11PM -0600, W. Michael Petullo wrote:
>>I have been using the dm-crypt interface to perform disk encryption.
>>For example, I helped add dm-crypt/LUKS support to HAL[1].
>>
>>Recently, I have found the cryptsetup no longer creates /dev/dm-X.
>>Instead, the only device node created by the utility is /dev/mapper/Y
>>(both were created previously.)  I am using an up to date Fedora Core 6.
>>
>>I am trying to figure out what user-space tool/library was responsible
>>for creating /dev/dm-X and why this device node is no longer created when
>>I create a dm-crypt device.  Could anyone point me in the right direction?
>you probably have an udev rule that ignores dm-[0-9]
>L.
>
btw, i read the code for blockdev_get_luks_uuid

sscanf? on the device file?

this is ridiculus what is sysfs for?

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
