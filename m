From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Multipath and SAN Fabric failover
Date: Thu, 07 Sep 2006 20:09:38 +0200
Message-ID: <45006062.6020800@bzed.de>
References: <20060907133943.4aa92481@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060907133943.4aa92481@localhost>
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

Heya,

I think you should just try an empty multipath.conf, only put the 
blacklist in. The EMC CX needs pp_emc as prio callout for example. The 
defaults within multipath should just work.
Also make sure your failovermode and arraycommpath are both set to 1. A 
few hints are mentioned on 
http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments
Please fill in if you find something that's missing there.

Best regards,

Bernd Zeimetz


John Little wrote:
> Hi all,
>
> I am trying to setup our server so that we have fabric failover from
> the san.  However my file sytem comes up read-only when I pull a cable
> for testing.
>
> I am using the following:
> SLES 10
> multipath-tools-0.4.6-25.8
> q-logic 2342 dual port hba
> emc cx600 san
> (4) McData DS-24 switches (2 for fabric a and 2 for fabric b)
>
>
>
> /etc/multipath.conf has the following entries:
>
> xen2:~ # grep -v "#" /etc/multipath.conf
> defaults {
>         udev_dir                /dev
>         polling_interval        10
>         selector                "round-robin 0"
>         getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>         prio_callout            /bin/true
>         failback                immediate
> }
> devnode_blacklist {
>         device {
>                 vendor SEAGATE
>                 product ST973401LSUN72G
>         }
> }
> multipaths {
>         multipath {
>                 wwid                    360060160f06109004352b218eb51da11
>                 alias                   capsprod
>                 path_grouping_policy    failover
>                 path_checker            readsector0
>                 path_selector           "round-robin 0"
>                 failback                immediate
>         }
> }
>
> Can someone point me in the right direction to get this resolved?
>
> Best regards,
> John Little, Network Systems
> Hendricks Regional Health
> http://hendrickshospital.org
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>   
