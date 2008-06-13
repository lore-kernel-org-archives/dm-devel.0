From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Multipathing.
Date: Fri, 13 Jun 2008 10:51:22 -0700
Message-ID: <110b17190806131051l33b60165ncf79d8cfd892008c@mail.gmail.com>
References: <F827A1300CC73247B0255EEEA5FFFB3BCA0A8AFCFE@ABGEX70E.FSC.NET>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F827A1300CC73247B0255EEEA5FFFB3BCA0A8AFCFE@ABGEX70E.FSC.NET>
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

Try the following:

http://sources.redhat.com/lvm2/wiki/MultipathUsageGuide

One can reach the same from the lvm wiki homepage
(http://sources.redhat.com/lvm2/wiki/HomePage) through the links "Usage
Documentation" -> "Multipath Usage Guide"

Courtesy Chandra.

Regards,
Pradipmaya.


2008/6/11 Ben El Hadj, Sami <Sami.Benelhadj@fujitsu-siemens.com>:
> Dear all,
>
> We want to implement Multipathing under linux redhat x86-64 AS U5 and two FC
> Emulex HBA LPe1150 and LPe11002
> we installed the following drivers : 8.0.16.40
>
> We applied the following steps to configurer MPIO:
>
> configure /etc/modprobe.conf
> make a new ramdisk
> edit and change the etc/multipath.conf
> multipathd start
> multipath -v2
> enable MPIO at boot
> multipath -v0
> multipathd restart
> multipath -v2
>
>
> under /dev/mapper we can find two devices VolGroup00-LogVol00  and
> VolGroup00-LogVol01 but multipath -ll oes not show any output
> can you please advise ?
> best regards
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
