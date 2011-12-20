From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: Re: how to troubleshoot faulty multipath path?
Date: Tue, 20 Dec 2011 14:45:04 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD910D14220@RTPMVEXC1-PRD.hq.netapp.com>
References: <4EEB6886.402@UGent.be><47D23AD8469A2B448F33C24BD7A39BD910C56472@RTPMVEXC1-PRD.hq.netapp.com>
	<20111217113450.35436m5i93gv279m@webmail.ugent.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20111217113450.35436m5i93gv279m@webmail.ugent.be>
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
> Sent: Saturday, December 17, 2011 4:35 AM
> To: dm-devel@redhat.com
> Subject: Re: [dm-devel] how to troubleshoot faulty multipath path?
> 
> Hello Mr Moger,
> 
> Quoting "Moger, Babu" <Babu.Moger@netapp.com>:
> 
> > My initial guess is, there could be problem with your configuration.
> > Can you paste output of "multipath -ll".  How does your
multipath.conf
> > look like.  Can you paste that as well.
> > You messages file might help also.
> 
> I have attached the output of multipath -ll.  My multipath.conf only
has some
> aliases defined, so I didn't attach that.  I'm using the default
config.
> 
> I've grepped through the messages, dmesg and kern.log files.  I have
> attached them.  (Adding the full files isn't possible they have other
> application level output too.)
> 
> I forgot to mention, I'm using 0.4.8+git0.761c66f-9 of
multipath-tools. (Debian
> stable)

None of your logs show any problems with the paths related to DS3400.
Can you please set the verbosity to 6 and collect the logs.
To set the verbosity level  add following line in default section in
your multipath.conf.
verbosity 	6

> 
> Thanks in advance!
> 
> 
> --
>   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
>   Rudy Gevaert                             e-mail:
Rudy.Gevaert@UGent.be
>   Directie ICT, Afdeling Infrastructuur
>   Groep Systemen                                      tel: +32 9 264
4750
>   Universiteit Gent                                   fax: +32 9 264
4994
>   Krijgslaan 281, gebouw S9, 9000 Gent, Belgie
www.UGent.be
>   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
