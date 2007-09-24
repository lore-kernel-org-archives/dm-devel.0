From: Nuno Fernandes <npf-mlists@eurotux.com>
Subject: Re: Device-mapper-multipath RDAC
Date: Mon, 24 Sep 2007 18:21:13 +0100
Message-ID: <200709241821.13708.npf-mlists@eurotux.com>
References: <200709241706.26322.npf-mlists@eurotux.com>
	<66F461DD7EDEEF4AA928FCC80B425B52AFCBEE@c2kp01mail.cucbc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <66F461DD7EDEEF4AA928FCC80B425B52AFCBEE@c2kp01mail.cucbc.com>
Content-Disposition: inline
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

I don't know Sun 6140, but for DS4700 the default for Linux is AVT enabled. 
I've disabled using scripts from storage manager.

What kernel version are u using? What about multipath tools? Can you send me 
your /etc/multipath.conf.

Have you tried to disconnect all fibres to the active controller of your SUN 
6140 to see if the LUNS jumps to the other controller?

Thanks
Nuno Fernandes


On Monday 24 September 2007 18:01:15 James Fillman wrote:
> I've just finished going through the process of getting our SAN gear
> working on RHEL5 with multipathing. I've got a Sun 6140 which I think is
> very similar to yours. They both are from ingenia. You'll want to use a
> *NON* AVT host type on the SAN.  I've set mine to type "Linux" and it
> works great.
>
> cheers,
> --james
>
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Nuno Fernandes
> Sent: Monday, September 24, 2007 9:06 AM
> To: device-mapper development
> Subject: [dm-devel] Device-mapper-multipath RDAC
>
> hello,
>
> Just a question:
>
> With recent support for rdac hardware handler in kernel 2.6.23-rc7, what
>
> configuration should be in storage DS4700? AVT (Automatic Volume
> transfer)
> turned on or off?
>
> When it's turned on, luns keep on jumping from controller to
> controller..
>
> Thanks
> Nuno Fernandes
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
