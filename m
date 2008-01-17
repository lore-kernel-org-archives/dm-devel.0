From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Need Help
Date: Thu, 17 Jan 2008 14:43:59 -0800
Message-ID: <110b17190801171443j37861520m2bb23fac6114f578@mail.gmail.com>
References: <1200605663.7183.81.camel@linuxchandra>
	<EEBC5C82F965344199BFA3E6047FE13302E8FF@SAUSEXMB2.amd.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <EEBC5C82F965344199BFA3E6047FE13302E8FF@SAUSEXMB2.amd.com>
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

I am not sure it it will help here but could you try this:

1. rename the exisiting multipath.conf to something (say multipath.conf.org)
2. create a new /etc/multipath.conf (blank file, do not copy it from
other multipath.conf.* files)
3. Copy the following content into it:
defaults {
        user_friendly_names yes
        selector   "round-robin 0"
}

devnode_blacklist {
        wwid 3600508e000000000ed7fb52911133c06
        devnode "^(ram|raw|loop|fd|md|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
}
4. reboot
5. lsmod | grep dm (it must show dm-multipath loaded)
6. run multipath -ll

We had a similar issue where the multipath.conf file won't be read
whatever you do, bu it went away after creating a new file (instead of
copying). Though weird, worth giving it a try.

Regards,
Pradipmaya.

On Jan 17, 2008 1:37 PM, Nath, Varun <varun.nath@amd.com> wrote:
> Default boot level is 3
>
> [root@x ~]# chkconfig multipathd --list
> multipathd      0:off   1:off   2:on    3:on    4:on    5:on    6:off
> [root@x ~]# who -r
>          run-level 3  Jan 17 15:04                   last=S
> [root@ausb3ndadbp02 ~]#
>
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Chandra Seetharaman
> Sent: Thursday, January 17, 2008 3:34 PM
> To: device-mapper development
> Subject: RE: [dm-devel] Need Help
>
>
> On Thu, 2008-01-17 at 15:10 -0600, Nath, Varun wrote:
> > This is what is happening as soon as the system comes up.
> >
> > There are no multipathing devices created. Once I run the multipath
> > command only then the /dev/mpath/mpath# devices get created. It looks
> > like I am missing some thing when the system boots up. The system has
> > the multipathd start up script in /etc/rc3.d.
>
> What does "chkconfig --list multipathd" show ?
>
> And what is default level you boot to (i.e what is initdefault
> in /etc/inittab) ?
>
> >
> > Any suggestions?
> >
>
> <snip>
>
> --
>
> ----------------------------------------------------------------------
>     Chandra Seetharaman               | Be careful what you choose....
>               - sekharan@us.ibm.com   |      .......you may get it.
> ----------------------------------------------------------------------
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
