From: "Stefan Bader" <sbader3@googlemail.com>
Subject: Re: performance considerations with IO schedulers and
	DMmultipathing
Date: Fri, 30 Nov 2007 14:02:31 +0100
Message-ID: <5201e28f0711300502k7f51ff55vd9f557a6a05fcdc@mail.gmail.com>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8CDD@exch-2003.incipient.waltham>
	<5201e28f0711271342s25dedae6j617f89c1d229b6c7@mail.gmail.com>
	<1D80D4F6D179BD4D869FE807A5BF8336012DCA51@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1593640349=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1D80D4F6D179BD4D869FE807A5BF8336012DCA51@EXCNYSM0A1AN.nysemail.nyenet>
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

--===============1593640349==
Content-Type: multipart/alternative;
	boundary="----=_Part_16841_11001366.1196427751553"

------=_Part_16841_11001366.1196427751553
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2007/11/30, Romanowski, John (OFT) <John.Romanowski@oft.state.ny.us>:
>
> Here's some links:
>
> Google cache of this article:
> "The basis for my test was to determine the best possible performance
> combination of elevator tuning AND /etc/multipath.conf rr_min_io setting."
>
> http://72.14.209.104/search?q=cache:q2p5HOwGxHwJ:www.techyblog.com/content/view/45/28/+Multipath+rr_min_io+Oracle+Elevator+Benchmarks&hl=en&ct=clnk&cd=1&gl=us


The thing is, that there are two settings that affect different drivers. The
I/O scheduler setting will affect the disks that are part of the multipath
volume (and only them), while the rr_min_io affects the multipath volume.
The higher the value of rr_min_io, the more requests are sent down one path
before switching to the next in the same path group. While this is good for
sequential I/O (because the elevator/scheduler on the underlying device can
merge more efficiently), this reduces the amount of I/O that is sent in
parallel. With very high rr_min_io settings you will end up using mostly one
path at a time, while the others are idle.
Using small values for rr_min_io, the chances of spreading the requests over
all paths are higher, but so is the chance of separating a long sequence
into smaller parts that are not sequential for the disk devices that make
the paths. Here a scheduler setting that copes with that pattern can help.
Another approach, that is not in the mainline kernel yet, is to introduce a
queue to the multipath target, merge sequential request there and send each
I/O down another path (like rr_min_io=1 would do). Kiyoshi Ueda from NEC had
a presentation about this on last years OLS (
https://ols2006.108.redhat.com/2007/Reprints/ueda-Reprint.pdf ). From their
evaluation of the current kernel, smaller rr_min_io values improved
performance but the best value was different for reads and writes.

Stefan

"The short summary of our study indicates that there is no SINGLE answer to
> which I/O scheduler is best."
> http://www.redhat.com/magazine/008jun05/features/schedulers/
>
> Oracle and linux I/O Scheduler
> part 1- http://www.nextre.it/oracledocs/ioscheduler_01.html
> part 2- http://www.nextre.it/oracledocs/ioscheduler_02.html
> part 3- http://www.nextre.it/oracledocs/ioscheduler_03.html
>
>
> --------------------------------------------------------
> This e-mail, including any attachments, may be confidential, privileged or
> otherwise legally protected. It is intended only for the addressee. If you
> received this e-mail in error or from someone who was not authorized to send
> it to you, do not disseminate, copy or otherwise use this e-mail or its
> attachments.  Please notify the sender immediately by reply e-mail and
> delete the e-mail from your system.
>
>
> -----Original Message-----
>
> From: dm-devel-bounces@redhat.com on behalf of Stefan Bader
> Sent: Tue 11/27/2007 4:42 PM
> To: device-mapper development
> Subject: Re: [dm-devel] performance considerations with IO schedulers and
> DMmultipathing
>
> Hi Paul,
>
> the device-mapper target itself doe not use any queue and so there is no
> scheduler used at all. Only the real devices that are used as paths will
> be
> using a scheduler. Whether there might be a performance gain by changing
> these, I do not know.
>
> Stefan
>
> 2007/11/27, Paul Cote <paul.cote@incipient.com>:
> >
> >  Hi,
> >
> > Is there any advantage to one specific IO scheduler (below) that may
> > improve IO performance / throughput when running with a round-robin
> failover
> > policy? Has anyone done testing with this ... and willing to share
> results?
> >
> > thanks,
> > Paul
> >
> > Completely Fair Queuing-elevator=cfq (default)
> > Deadline-elevator=deadline
> > NOOP-elevator=noop
> > Anticipatory-elevator=as
> >
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_16841_11001366.1196427751553
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div><span class="gmail_quote">2007/11/30, Romanowski, John (OFT) &lt;<a href="mailto:John.Romanowski@oft.state.ny.us">John.Romanowski@oft.state.ny.us</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Here&#39;s some links:<br><br>Google cache of this article:<br>&quot;The basis for my test was to determine the best possible performance combination of elevator tuning AND /etc/multipath.conf rr_min_io setting.&quot;<br>
<a href="http://72.14.209.104/search?q=cache:q2p5HOwGxHwJ:www.techyblog.com/content/view/45/28/+Multipath+rr_min_io+Oracle+Elevator+Benchmarks&amp;hl=en&amp;ct=clnk&amp;cd=1&amp;gl=us">http://72.14.209.104/search?q=cache:q2p5HOwGxHwJ:www.techyblog.com/content/view/45/28/+Multipath+rr_min_io+Oracle+Elevator+Benchmarks&amp;hl=en&amp;ct=clnk&amp;cd=1&amp;gl=us
</a></blockquote><div><br>The thing is, that there are two settings that affect different drivers. The I/O scheduler setting will affect the disks that are part of the multipath volume (and only them), while the rr_min_io affects the multipath volume.
<br>The higher the value of rr_min_io, the more requests are sent down one path before switching to the next in the same path group. While this is good for sequential I/O (because the elevator/scheduler on the underlying device can merge more efficiently), this reduces the amount of I/O that is sent in parallel. With very high rr_min_io settings you will end up using mostly one path at a time, while the others are idle.
<br>Using small values for rr_min_io, the chances of spreading the requests over all paths are higher, but so is the chance of separating a long sequence into smaller parts that are not sequential for the disk devices that make the paths. Here a scheduler setting that copes with that pattern can help.
<br>Another approach, that is not in the mainline kernel yet, is to introduce a queue to the multipath target, merge sequential request there and send each I/O down another path (like rr_min_io=1 would do). Kiyoshi Ueda from NEC had a presentation about this on last years OLS (
<a href="https://ols2006.108.redhat.com/2007/Reprints/ueda-Reprint.pdf">https://ols2006.108.redhat.com/2007/Reprints/ueda-Reprint.pdf</a> ). From their evaluation of the current kernel, smaller rr_min_io values improved performance but the best value was different for reads and writes.
<br></div><br>Stefan<br><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">&quot;The short summary of our study indicates that there is no SINGLE answer to which I/O scheduler is best.&quot;
<br><a href="http://www.redhat.com/magazine/008jun05/features/schedulers/">http://www.redhat.com/magazine/008jun05/features/schedulers/</a><br><br>Oracle and linux I/O Scheduler<br>part 1- <a href="http://www.nextre.it/oracledocs/ioscheduler_01.html">
http://www.nextre.it/oracledocs/ioscheduler_01.html</a><br>part 2- <a href="http://www.nextre.it/oracledocs/ioscheduler_02.html">http://www.nextre.it/oracledocs/ioscheduler_02.html</a><br>part 3- <a href="http://www.nextre.it/oracledocs/ioscheduler_03.html">
http://www.nextre.it/oracledocs/ioscheduler_03.html</a><br><br><br>--------------------------------------------------------<br>This e-mail, including any attachments, may be confidential, privileged or otherwise legally protected. It is intended only for the addressee. If you received this e-mail in error or from someone who was not authorized to send it to you, do not disseminate, copy or otherwise use this e-mail or its attachments.&nbsp;&nbsp;Please notify the sender immediately by reply e-mail and delete the e-mail from your system.
<br><br><br>-----Original Message-----<br><br>From: <a href="mailto:dm-devel-bounces@redhat.com">dm-devel-bounces@redhat.com</a> on behalf of Stefan Bader<br>Sent: Tue 11/27/2007 4:42 PM<br>To: device-mapper development<br>
Subject: Re: [dm-devel] performance considerations with IO schedulers and DMmultipathing<br><br>Hi Paul,<br><br>the device-mapper target itself doe not use any queue and so there is no<br>scheduler used at all. Only the real devices that are used as paths will be
<br>using a scheduler. Whether there might be a performance gain by changing<br>these, I do not know.<br><br>Stefan<br><br>2007/11/27, Paul Cote &lt;<a href="mailto:paul.cote@incipient.com">paul.cote@incipient.com</a>&gt;:
<br>&gt;<br>&gt;&nbsp;&nbsp;Hi,<br>&gt;<br>&gt; Is there any advantage to one specific IO scheduler (below) that may<br>&gt; improve IO performance / throughput when running with a round-robin failover<br>&gt; policy? Has anyone done testing with this ... and willing to share results?
<br>&gt;<br>&gt; thanks,<br>&gt; Paul<br>&gt;<br>&gt; Completely Fair Queuing-elevator=cfq (default)<br>&gt; Deadline-elevator=deadline<br>&gt; NOOP-elevator=noop<br>&gt; Anticipatory-elevator=as<br>&gt;<br>&gt;<br>&gt;<br>
&gt; --<br>&gt; dm-devel mailing list<br>&gt; <a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>&gt; <a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel
</a><br>&gt;<br><br><br>--<br>dm-devel mailing list<br><a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel
</a><br></blockquote></div><br>

------=_Part_16841_11001366.1196427751553--


--===============1593640349==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1593640349==--
