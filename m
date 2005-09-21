From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath conf file "device {}" support
Date: Wed, 21 Sep 2005 22:58:20 +0200
Message-ID: <1127336300.14912.39.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AC9F@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AC9F@SRMANNING.eng.emc.com>
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
List-Id: dm-devel.ids

Legitimate, done.
Will appear in git tree in a few minutes.

Regards,

On mer, 2005-09-14 at 21:49 -0400, goggin, edward wrote:
> I'm wondering why when I put "device {}" entries in the multipath conf file
> I
> lose all of the other entries setup in the libmultipath/hwtable.c file.
> Devices
> which do not match the vendor and model strings of the device entries I
> setup in the conf file are all forced to pick up default multipath
> attributes.
> 
> This approach forces me to know the attributes for all vendor/model device
> types in my SAN configuration whenever I want to setup even a small change
> in the device attributes for a single device type.
> 
> I would rather see the that the entries that are setup in the conf file
> simply
> override the ones setup in the hwtable.c file.  Yet, entries already setup
> in
> the hwtable.c file which are not overridden remain valid.  The only devices
> which pick up defaults are ones for which there is not a device entry in
> either the libmultipath/hwtable.c file or the multipath conf file.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
