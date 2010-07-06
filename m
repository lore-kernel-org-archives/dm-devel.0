From: bart.coninckx@telenet.be
Subject: Re: understanding of multipathing and speed
Date: Tue, 6 Jul 2010 10:07:06 +0200 (CEST)
Message-ID: <485728250.294571278403626576.JavaMail.root@tendai.telenet-ops.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2165792103679848681=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2165792103679848681==
Content-Type: multipart/alternative;
	boundary="----=_Part_15124_491955600.1278403626574"

------=_Part_15124_491955600.1278403626574
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit



On Tuesday 06 July 2010 09:21:51 Christophe Varoqui wrote: 

> (1494554000000000000000000010000000200000002000000) dm-1 

> 

> > IET,VIRTUAL-DISK [size=40G][features=1 queue_if_no_path][hwhandler=0] 

> > \_ round-robin 0 [prio=-2][active] 

> > \_ 1:0:0:2 sdf 8:80 [active][undef] 

> > \_ 2:0:0:2 sdg 8:96 [active][undef] 

> > 

> > I have two Gigabit NICs in this server each running over a separate 

> > switch to a separate gigabit NIC with a unique IP address on the 

> > storage IET iSCSI target. 

> 

> did you setup different ip networks for each independant lan ? You may want 

> to verify the ip routing is not sending every other packet through the 

> wrong interface ? 

> 

> Bye 

> 







Hi Christophe, 



yes I did, the two initiators and targets have there own IP network. IP 

routing points to the correct interface per network. Maybe my test (bonnie++) 

is not an appropriate one to show the difference in speed? 



thx, 



Bart 


------=_Part_15124_491955600.1278403626574
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html><head><style type='text/css'>p { margin: 0; }</style></head><body><div style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000'>
<meta name="qrichtext" content="1"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">
p, li { white-space: pre-wrap; }
</style>
<p style="margin: 0px; text-indent: 0px;"><!--StartFragment-->On Tuesday 06 July 2010 09:21:51 Christophe Varoqui wrote:</p>
<p style="margin: 0px; text-indent: 0px;">&gt; (1494554000000000000000000010000000200000002000000) dm-1</p>
<p style="margin: 0px; text-indent: 0px;">&gt; </p>
<p style="margin: 0px; text-indent: 0px;">&gt; &gt; IET,VIRTUAL-DISK [size=40G][features=1 queue_if_no_path][hwhandler=0]</p>
<p style="margin: 0px; text-indent: 0px;">&gt; &gt; \_ round-robin 0 [prio=-2][active]</p>
<p style="margin: 0px; text-indent: 0px;">&gt; &gt;   \_ 1:0:0:2 sdf 8:80   [active][undef]</p>
<p style="margin: 0px; text-indent: 0px;">&gt; &gt;   \_ 2:0:0:2 sdg 8:96   [active][undef]</p>
<p style="margin: 0px; text-indent: 0px;">&gt; &gt;</p>
<p style="margin: 0px; text-indent: 0px;">&gt; &gt; I have two Gigabit NICs in this server each running over a separate</p>
<p style="margin: 0px; text-indent: 0px;">&gt; &gt; switch to   a separate gigabit NIC with a unique IP address on the</p>
<p style="margin: 0px; text-indent: 0px;">&gt; &gt; storage IET iSCSI   target.</p>
<p style="margin: 0px; text-indent: 0px;">&gt; </p>
<p style="margin: 0px; text-indent: 0px;">&gt; did you setup different ip networks for each independant lan ? You may want</p>
<p style="margin: 0px; text-indent: 0px;">&gt;  to verify the ip routing is not sending every other packet through the</p>
<p style="margin: 0px; text-indent: 0px;">&gt;  wrong interface ?</p>
<p style="margin: 0px; text-indent: 0px;">&gt; </p>
<p style="margin: 0px; text-indent: 0px;">&gt; Bye</p>
<p style="margin: 0px; text-indent: 0px;">&gt; <br></p><p style="margin: 0px; text-indent: 0px;"><br></p>
<p style="margin: 0px; text-indent: 0px;"></p>
<p style="margin: 0px; text-indent: 0px;">Hi Christophe,</p>
<p style="margin: 0px; text-indent: 0px;"></p>
<p style="margin: 0px; text-indent: 0px;">yes I did, the two initiators and targets have there own IP network.  IP </p>
<p style="margin: 0px; text-indent: 0px;">routing points to the correct interface per network. Maybe my test (bonnie++) </p>
<p style="margin: 0px; text-indent: 0px;">is not an appropriate one to show the difference in speed?</p>
<p style="margin: 0px; text-indent: 0px;"></p>
<p style="margin: 0px; text-indent: 0px;">thx,</p>
<p style="margin: 0px; text-indent: 0px;"></p>
<p style="margin: 0px; text-indent: 0px;">Bart</p>
<p style="margin: 0px; text-indent: 0px;"><!--EndFragment--></p></div></body></html>
------=_Part_15124_491955600.1278403626574--


--===============2165792103679848681==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2165792103679848681==--
