From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: Re: how to troubleshoot faulty multipath path?
Date: Wed, 21 Dec 2011 11:57:49 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD910D14466@RTPMVEXC1-PRD.hq.netapp.com>
References: <4EEB6886.402@UGent.be><47D23AD8469A2B448F33C24BD7A39BD910C56472@RTPMVEXC1-PRD.hq.netapp.com>	<20111217113450.35436m5i93gv279m@webmail.ugent.be><47D23AD8469A2B448F33C24BD7A39BD910D14220@RTPMVEXC1-PRD.hq.netapp.com>
	<4EF207F8.7030904@UGent.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4EF207F8.7030904@UGent.be>
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



> -----Original Message-----
> From: Rudy Gevaert [mailto:Rudy.Gevaert@UGent.be]
> Sent: Wednesday, December 21, 2011 10:23 AM
> To: dm-devel@redhat.com
> Subject: Re: [dm-devel] how to troubleshoot faulty multipath path?
> 
> On 12/20/2011 08:45 PM, Moger, Babu wrote:
> 
> > None of your logs show any problems with the paths related to
DS3400.
> > Can you please set the verbosity to 6 and collect the logs.
> > To set the verbosity level  add following line in default section in
> > your multipath.conf.
> > verbosity 	6
> 
> Hello,
> 
> I have changed the verbosity level to 6.  I have attached the output
of
> multipath -l.
> 
> Do you need any other logs?


There are problem with few devices.  Open itself is failing. 

Look here..
Dec 21 17:23:02 | Discover device /sys/block/sdd
Dec 21 17:23:02 | sdd: not found in pathvec
Dec 21 17:23:02 | sdd: mask = 0x1
Dec 21 17:23:02 | sdd: dev_t = 8:48
Dec 21 17:23:02 | sdd: size = 1153433600
Dec 21 17:23:02 | sdd: subsystem = scsi
Dec 21 17:23:02 | sdd: vendor = IBM
Dec 21 17:23:02 | sdd: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdd: rev = 0617
Dec 21 17:23:02 | sdd: h:b:t:l = 1:0:0:11
Dec 21 17:23:02 | sdd: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Couldn't open node for sdd: No such device or address

Dec 21 17:23:02 | Discover device /sys/block/sdq
Dec 21 17:23:02 | sdq: not found in pathvec
Dec 21 17:23:02 | sdq: mask = 0x1
Dec 21 17:23:02 | sdq: dev_t = 65:0
Dec 21 17:23:02 | sdq: size = 1153433600
Dec 21 17:23:02 | sdq: subsystem = scsi
Dec 21 17:23:02 | sdq: vendor = IBM
Dec 21 17:23:02 | sdq: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdq: rev = 0617
Dec 21 17:23:02 | sdq: h:b:t:l = 5:0:0:10
Dec 21 17:23:02 | sdq: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Couldn't open node for sdq: No such device or address

Dec 21 17:23:02 | Discover device /sys/block/sdv
Dec 21 17:23:02 | sdv: not found in pathvec
Dec 21 17:23:02 | sdv: mask = 0x1
Dec 21 17:23:02 | sdv: dev_t = 65:80
Dec 21 17:23:02 | sdv: size = 1153433600
Dec 21 17:23:02 | sdv: subsystem = scsi
Dec 21 17:23:02 | sdv: vendor = IBM
Dec 21 17:23:02 | sdv: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdv: rev = 0617
Dec 21 17:23:02 | sdv: h:b:t:l = 5:0:0:15
Dec 21 17:23:02 | sdv: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Couldn't open node for sdv: No such device or address

If you have sg_utils, you can try sending some commands to these
devices.

> 
> Thanks in advance!
> Rudy
