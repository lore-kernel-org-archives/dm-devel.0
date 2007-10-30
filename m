From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: Re: NIC and HBA based multipathing
Date: Tue, 30 Oct 2007 13:40:50 -0400
Message-ID: <5fb0f77b0710301040l4eeca0a7n2ccdc00b14285294@mail.gmail.com>
References: <342d47870710300956k3bde2d06j7a50acc6c8225fe5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2081512264=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870710300956k3bde2d06j7a50acc6c8225fe5@mail.gmail.com>
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

--===============2081512264==
Content-Type: multipart/alternative;
	boundary="----=_Part_7589_31273419.1193766050645"

------=_Part_7589_31273419.1193766050645
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I cant say that I have done that all mine are on an iscsi HBA only but, it
seems like it should work ..
you will need to have multipathd running, and you will have to setup your
/etc/multipath.conf file correctly for your device(s). Also this goes with
out saying each initiator will need the target defined
for their own access.

RHEL:
> rpm -qa | grep multipath
device-mapper-multipath-0.4.5-21.0.1.RHEL4
> chkconfig multipathd on

You will also note that your devices will vary /dev/sdX which is fine they
will
be "joined" if you will under the /dev/mpath/<whatever-you-called-dev> node.

Which is where you will access the device as well.


On 10/30/07, Scott Moseman <scmoseman@gmail.com> wrote:
>
> Device-mapper multipathing in RHEL 4
> http://kbase.redhat.com/faq/FAQ_51_7170.shtm
>
> I can (and have) setup a NIC based iSCSI SAN connection.  I can (and
> have) setup an HBA based iSCSI SAN connection.  Now I'm trying to get
> a machine to connect using multipath with both a NIC and an HBA.  What
> are the prerequisites that I should have running before I attempt to
> go through the above knowledge base procedure?
>
> I put IPs on both the NIC and HBA on the SAN network.  The SAN is
> showing both IPs as trying to access the volume in question.  iscsi-ls
> only shows 1 device (/dev/sdb), and it's taking the path through the
> NIC to reach the SAN.  I can verify this by watching the SAN volume to
> see which of the IP addresses is sending traffic.
>
> Should my HBA show up as another device (/dev/sdc) before I start
> attempting to multipath?  Or is multipathd going to link both NIC and
> HBA to the /dev/sdb device?
>
> Thanks,
> Scott
>

------=_Part_7589_31273419.1193766050645
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I cant say that I have done that all mine are on an iscsi HBA only but, it seems like it should work .. <br>you will need to have multipathd running, and you will have to setup your <br>/etc/multipath.conf file correctly for your device(s). Also this goes with out saying each initiator will need the target defined
<br>for their own access.<br><br>RHEL:<br>&gt; rpm -qa | grep multipath<br>device-mapper-multipath-0.4.5-21.0.1.RHEL4<br>&gt; chkconfig multipathd on<br><br>You will also note that your devices will vary /dev/sdX which is fine they will 
<br>be &quot;joined&quot; if you will under the /dev/mpath/&lt;whatever-you-called-dev&gt; node. <br>Which is where you will access the device as well.<br><br><br><div><span class="gmail_quote">On 10/30/07, <b class="gmail_sendername">
Scott Moseman</b> &lt;<a href="mailto:scmoseman@gmail.com">scmoseman@gmail.com</a>&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Device-mapper multipathing in RHEL 4<br><a href="http://kbase.redhat.com/faq/FAQ_51_7170.shtm">http://kbase.redhat.com/faq/FAQ_51_7170.shtm</a><br><br>I can (and have) setup a NIC based iSCSI SAN connection.&nbsp;&nbsp;I can (and<br>
have) setup an HBA based iSCSI SAN connection.&nbsp;&nbsp;Now I&#39;m trying to get<br>a machine to connect using multipath with both a NIC and an HBA.&nbsp;&nbsp;What<br>are the prerequisites that I should have running before I attempt to<br>
go through the above knowledge base procedure?<br><br>I put IPs on both the NIC and HBA on the SAN network.&nbsp;&nbsp;The SAN is<br>showing both IPs as trying to access the volume in question.&nbsp;&nbsp;iscsi-ls<br>only shows 1 device (/dev/sdb), and it&#39;s taking the path through the
<br>NIC to reach the SAN.&nbsp;&nbsp;I can verify this by watching the SAN volume to<br>see which of the IP addresses is sending traffic.<br><br>Should my HBA show up as another device (/dev/sdc) before I start<br>attempting to multipath?&nbsp;&nbsp;Or is multipathd going to link both NIC and
<br>HBA to the /dev/sdb device?<br><br>Thanks,<br>Scott<br></blockquote></div><br><br clear="all"><br>

------=_Part_7589_31273419.1193766050645--


--===============2081512264==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2081512264==--
