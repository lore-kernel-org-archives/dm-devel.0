From: "Stefan Bader" <sbader3@googlemail.com>
Subject: Re: user defined device name and table
Date: Mon, 26 Nov 2007 17:44:03 +0100
Message-ID: <5201e28f0711260844r425847c0ta28ee0f988c5906@mail.gmail.com>
References: <474ADDCF.8030703@fccn.pt>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2088912838=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <474ADDCF.8030703@fccn.pt>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: pedro.faustino@fccn.pt, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2088912838==
Content-Type: multipart/alternative;
	boundary="----=_Part_2593_6435309.1196095443290"

------=_Part_2593_6435309.1196095443290
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2007/11/26, Pedro Bandim Faustino <pedro.faustino@fccn.pt>:
>
> Hi All,
>
> I have a working multipath on root, but some questions still unanswered.
> I'm hoping you can help me out ;)
>
> My setup details:
> Machine: IBM Blade Server HS21 with two Qlogic HBAs each connected to a
> FC switch with two active ports
> Storage IBM DS4700 with two controllers
> OS: Fedora 7
> DM packages:
>     - device-mapper-1.02.17-7.fc7
>     - device-mapper-libs-1.02.17-7.fc7
>     - device-mapper-multipath-0.4.7-11.fc7
> uname -r: 2.6.23.1-21.fc7
>
> At the moment this is what I have:
>
> Output of multipath -ll:
> mpath0 () dm-0 IBM,1814      FAStT
> [size=4.0G][features=0][hwhandler=0]
> \_ round-robin 0 [prio=4][active]
> \_ 2:0:0:0 sda 8:0   [active][ready]
> \_ 2:0:1:0 sdb 8:16  [active][ready]
> \_ 3:0:0:0 sdc 8:32  [active][ready]
> \_ 3:0:1:0 sdd 8:48  [active][ready]
>
> Output of df -k:
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/dm-2              3960348   1772124   1983800  48% /
> /dev/dm-1               101086     17593     78274  19% /boot
> tmpfs                  1037416         0   1037416   0% /dev/shm
>
> Contents of /dev/mapper/:
> crw-------  1 root root  10, 63 2007-11-26 13:58 control
> brw-rw----  1 root disk 253,  0 2007-11-26 13:58 mpath0
> brw-rw----  1 root disk 253,  1 2007-11-26 13:58 mpath0p1
> brw-rw----  1 root disk 253,  2 2007-11-26 13:58 mpath0p2
>
> But this is what I really would like to have:
>
> Output of multipath -ll:
> SRV07_BOOT (3600a0b8000295d64000009304742b4c8) dm-0 IBM,1814      FAStT
> [size=4.0G][features=1 queue_if_no_path][hwhandler=0]
> \_ round-robin 0 [prio=0][enabled]
> \_ 2:0:0:0 sda 8:0   [active][ready]
> \_ 3:0:0:0 sdc 8:32  [active][ready]
> \_ round-robin 0 [prio=6][active]
> \_ 2:0:1:0 sdb 8:16  [active][ready]
> \_ 3:0:1:0 sdd 8:48  [active][ready]
>
>
> I can modify the table by modifying the init script in the initrd image
> and then booting with the modified initrd image but I don't know how to
> change the name from mpath0 to SRV07_BOOT.


You should be able to change the name by creating a multipaths section like
below

multipaths {
    multipath {
        wwid "3600a0b8000295d64000009304742b4c8"
        alias "SRV07_BOOT"
    }
}

If that does not work as expected, you might have to say "no" to the user
friendly names option.

Any help will be very appreciated!!
>
> Thank you,
> Pedro Faustino
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>

------=_Part_2593_6435309.1196095443290
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div><span class="gmail_quote">2007/11/26, Pedro Bandim Faustino &lt;<a href="mailto:pedro.faustino@fccn.pt">pedro.faustino@fccn.pt</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi All,<br><br>I have a working multipath on root, but some questions still unanswered.<br>I&#39;m hoping you can help me out ;)<br><br>My setup details:<br>Machine: IBM Blade Server HS21 with two Qlogic HBAs each connected to a
<br>FC switch with two active ports<br>Storage IBM DS4700 with two controllers<br>OS: Fedora 7<br>DM packages:<br>&nbsp;&nbsp;&nbsp;&nbsp;- device-mapper-1.02.17-7.fc7<br>&nbsp;&nbsp;&nbsp;&nbsp;- device-mapper-libs-1.02.17-7.fc7<br>&nbsp;&nbsp;&nbsp;&nbsp;- device-mapper-multipath-0.4.7-11.fc7
<br>uname -r: 2.6.23.1-21.fc7<br><br>At the moment this is what I have:<br><br>Output of multipath -ll:<br>mpath0 () dm-0 IBM,1814&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAStT<br>[size=4.0G][features=0][hwhandler=0]<br>\_ round-robin 0 [prio=4][active]<br>
 \_ 2:0:0:0 sda 8:0&nbsp;&nbsp; [active][ready]<br> \_ 2:0:1:0 sdb 8:16&nbsp;&nbsp;[active][ready]<br> \_ 3:0:0:0 sdc 8:32&nbsp;&nbsp;[active][ready]<br> \_ 3:0:1:0 sdd 8:48&nbsp;&nbsp;[active][ready]<br><br>Output of df -k:<br>Filesystem&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1K-blocks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Used Available Use% Mounted on
<br>/dev/dm-2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3960348&nbsp;&nbsp; 1772124&nbsp;&nbsp; 1983800&nbsp;&nbsp;48% /<br>/dev/dm-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 101086&nbsp;&nbsp;&nbsp;&nbsp; 17593&nbsp;&nbsp;&nbsp;&nbsp; 78274&nbsp;&nbsp;19% /boot<br>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1037416&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; 1037416&nbsp;&nbsp; 0% /dev/shm<br><br>Contents of /dev/mapper/:
<br>crw-------&nbsp;&nbsp;1 root root&nbsp;&nbsp;10, 63 2007-11-26 13:58 control<br>brw-rw----&nbsp;&nbsp;1 root disk 253,&nbsp;&nbsp;0 2007-11-26 13:58 mpath0<br>brw-rw----&nbsp;&nbsp;1 root disk 253,&nbsp;&nbsp;1 2007-11-26 13:58 mpath0p1<br>brw-rw----&nbsp;&nbsp;1 root disk 253,&nbsp;&nbsp;2 2007-11-26 13:58 mpath0p2
<br><br>But this is what I really would like to have:<br><br>Output of multipath -ll:<br>SRV07_BOOT (3600a0b8000295d64000009304742b4c8) dm-0 IBM,1814&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAStT<br>[size=4.0G][features=1 queue_if_no_path][hwhandler=0]<br>
\_ round-robin 0 [prio=0][enabled]<br> \_ 2:0:0:0 sda 8:0&nbsp;&nbsp; [active][ready]<br> \_ 3:0:0:0 sdc 8:32&nbsp;&nbsp;[active][ready]<br>\_ round-robin 0 [prio=6][active]<br> \_ 2:0:1:0 sdb 8:16&nbsp;&nbsp;[active][ready]<br> \_ 3:0:1:0 sdd 8:48&nbsp;&nbsp;[active][ready]
<br><br><br>I can modify the table by modifying the init script in the initrd image<br>and then booting with the modified initrd image but I don&#39;t know how to<br>change the name from mpath0 to SRV07_BOOT.</blockquote>
<div><br>You should be able to change the name by creating a multipaths section like below<br><br>multipaths {<br>&nbsp;&nbsp;&nbsp; multipath {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wwid &quot;3600a0b8000295d64000009304742b4c8&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; alias &quot;SRV07_BOOT&quot;
<br>&nbsp;&nbsp;&nbsp; }<br>}<br></div><br>If that does not work as expected, you might have to say &quot;no&quot; to the user friendly names option.<br><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Any help will be very appreciated!!<br><br>Thank you,<br>Pedro Faustino<br><br>--<br>dm-devel mailing list<br><a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href="https://www.redhat.com/mailman/listinfo/dm-devel">
https://www.redhat.com/mailman/listinfo/dm-devel</a><br><br></blockquote></div><br>

------=_Part_2593_6435309.1196095443290--


--===============2088912838==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2088912838==--
