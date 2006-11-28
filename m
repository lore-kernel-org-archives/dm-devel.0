From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: system freeze/console flood when unplugging one path
	of multipath disk array
Date: Tue, 28 Nov 2006 15:11:21 -0600
Message-ID: <20061128211121.GB14134@ether.msp.redhat.com>
References: <456C1B1B.5030109@pclella.cern.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <456C1B1B.5030109@pclella.cern.ch>
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

On Tue, Nov 28, 2006 at 12:18:51PM +0100, Rainer Toebbicke wrote:
> Hello,
> 
> I've got a Sun 3510 disk array and a dual-channel Qlogic FC HBA, in a 
> Sun X4100 under RHEL4 U4,  each path connected to the array over a 
> qlogic 5600 switch.
> 
> The devices are seen correctly with multipath -l as far as I can judge.
> 
> 
> When I disable one of the paths during a stress test (in this case, an 
> fsck -y), the system "freezes". Actually, it just sends enough 
> (thousands) error messages of the style
> 
> end_request: I/O error, dev sdb, sector 279446024
> Buffer I/O error on device sdb1, logical block 279445961

You wouldn't happen to be doing IO directly to /dev/sdb1, would you? If
so, you need to be doing IO to a kpartx created device on top of your
multipathed device.

> lost page write due to I/O error on sdb1
> SCSI error : <1 0 0 1> return code = 0x10000
> end_request: I/O error, dev sdb, sector 279446025
> Buffer I/O error on device sdb1, logical block 279445962
> lost page write due to I/O error on sdb1
> SCSI error : <1 0 0 1> return code = 0x10000
> end_request: I/O error, dev sdb, sector 279446026
> Buffer I/O error on device sdb1, logical block 279445963
> lost page write due to I/O error on sdb1
> SCSI error : <1 0 0 1> return code = 0x10000
> end_request: I/O error, dev sdb, sector 279446027
> Buffer I/O error on device sdb1, logical block 279445964
> lost page write due to I/O error on sdb1
> SCSI error : <1 0 0 1> return code = 0x10000
> 
> 
> to the serial console to make it appear completely stuck for hours.
> 
> The fsck does not finish, BTW, it restarts from the beginning as soon 
> as I re-enable the port in the switch.
> 
> root@afs26 ~]# multipath -l
> mpath2 (3600c0ff0000000000a792a1887b34100)
> [size=136 GB][features="1 queue_if_no_path"][hwhandler="0"]
> \_ round-robin 0 [active]
>  \_ 1:0:0:3  sdc 8:32  [active][ready]
>  \_ 2:0:0:3  sdi 8:128 [active][ready]
> 
> mpath1 (3600c0ff0000000000a792a0aac9b4200)
> [size=136 GB][features="1 queue_if_no_path"][hwhandler="0"]
> \_ round-robin 0 [active]
>  \_ 1:0:0:1  sdb 8:16  [active][ready]
>  \_ 2:0:0:1  sdh 8:112 [active][ready]
> ....
> 
> /etc/multipath.conf just contains
> defaults {
>         default_features "1 queue_if_no_path"
>         user_friendly_names yes
> 
> }
> 
> besides the usual blacklist.
> 
> Any ideas?
> 
> -- 
> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> Rainer Toebbicke
> European Laboratory for Particle Physics(CERN) - Geneva, Switzerland
> Phone: +41 22 767 8985       Fax: +41 22 767 7155
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
