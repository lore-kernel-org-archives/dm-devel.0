From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Thu, 15 Nov 2007 21:42:55 +0100
Message-ID: <5201e28f0711151242u8f0fd0h51e0355a53526e82@mail.gmail.com>
References: <5201e28f0711101625r19ceaf11yd3727c424f27b7d8@mail.gmail.com>
	<20071113201804.GJ28113@ether.msp.redhat.com>
	<5201e28f0711131517p79fc4a8dk1da9bda922c3093e@mail.gmail.com>
	<20071114.154456.71084719.k-ueda@ct.jp.nec.com>
	<20071115192428.GD4900@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0426298188=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071115192428.GD4900@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0426298188==
Content-Type: multipart/alternative;
	boundary="----=_Part_7578_30752502.1195159375926"

------=_Part_7578_30752502.1195159375926
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2007/11/15, Benjamin Marzinski <bmarzins@redhat.com>:
>
>
> > What do you think?
>
> On the other hand, I agree with Stefan that there will be issues with
> trying to gather the sysfs information for devices that just don't have
> it.  Like he said, you can ignore them, but I wonder if this might cause
> problems for the rare, but still possible, case where you expect that
> a device should properly provide all its sysfs information, but for some
> reason, you can't get it. In this case the device would most likely be
> silently ignored.  Obviously, we can provide the information if you run
> the commands with a higher verbosity.


I think this wouls be acceptable. I am not sure whether any useful device
that is used for multipathing is not required to provide a /sys/block/device
link and a vendor/model attributes there. As long as the reason for which a
device is dropped can be seen with a higher verbosity level this should be
fine.

The bigger issue I have is that there should be a way to tell multipath,
> "Don't do anything."  Many people have a multipath package installed on
> their systems that they don't even know about, and they don't want it to
> do anything.  Right now, if you have
>
> blacklist {
>         devnode ".*"
> }
>
> You pretty much get that behaviour. If anything on their system happens
> to run the multipath command, nothing much really happens.  With this
> method, your adding more things that multipath has to do before if
> realizes that it shouldn't be doing anything. Of course this could
> easily be solved by adding the parameter to the defaults section of
> multipath.conf.
>
> defaults {
>         disable yes
> }
>
> This would allow multipath to quit immediately after reading the config
> file, and it would seperate the choice to disable multipath from the
> blacklist setup.


Would it really hurt that much if multipath has to go through some devices
before doing nothing? I think it should not take that much time to go
through /sys/block and gather that initial information.

Regards,
Stefan

------=_Part_7578_30752502.1195159375926
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div><span class="gmail_quote">2007/11/15, Benjamin Marzinski &lt;<a href="mailto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>&gt; What do you think?<br><br>On the other hand, I agree with Stefan that there will be issues with<br>trying to gather the sysfs information for devices that just don&#39;t have<br>it.&nbsp;&nbsp;Like he said, you can ignore them, but I wonder if this might cause
<br>problems for the rare, but still possible, case where you expect that<br>a device should properly provide all its sysfs information, but for some<br>reason, you can&#39;t get it. In this case the device would most likely be
<br>silently ignored.&nbsp;&nbsp;Obviously, we can provide the information if you run<br>the commands with a higher verbosity.</blockquote><div><br>I think this wouls be acceptable. I am not sure whether any useful device that is used for multipathing is not required to provide a /sys/block/device link and a vendor/model attributes there. As long as the reason for which a device is dropped can be seen with a higher verbosity level this should be fine.
<br></div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">The bigger issue I have is that there should be a way to tell multipath,<br>&quot;Don&#39;t do anything.&quot;&nbsp;&nbsp;Many people have a multipath package installed on
<br>their systems that they don&#39;t even know about, and they don&#39;t want it to<br>do anything.&nbsp;&nbsp;Right now, if you have<br><br>blacklist {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;.*&quot;<br>}<br><br>You pretty much get that behaviour. If anything on their system happens
<br>to run the multipath command, nothing much really happens.&nbsp;&nbsp;With this<br>method, your adding more things that multipath has to do before if<br>realizes that it shouldn&#39;t be doing anything. Of course this could<br>
easily be solved by adding the parameter to the defaults section of<br>multipath.conf.<br><br>defaults {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;disable yes<br>}<br><br>This would allow multipath to quit immediately after reading the config<br>file, and it would seperate the choice to disable multipath from the
<br>blacklist setup.</blockquote><div><br>Would it really hurt that much if multipath has to go through some devices before doing nothing? I think it should not take that much time to go through /sys/block and gather that initial information.
<br><br>Regards,<br>Stefan<br></div></div>

------=_Part_7578_30752502.1195159375926--


--===============0426298188==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0426298188==--
