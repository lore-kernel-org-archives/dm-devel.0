From: "Scott Moseman" <scmoseman@gmail.com>
Subject: NIC and HBA based multipathing
Date: Tue, 30 Oct 2007 11:56:08 -0500
Message-ID: <342d47870710300956k3bde2d06j7a50acc6c8225fe5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Device-mapper multipathing in RHEL 4
http://kbase.redhat.com/faq/FAQ_51_7170.shtm

I can (and have) setup a NIC based iSCSI SAN connection.  I can (and
have) setup an HBA based iSCSI SAN connection.  Now I'm trying to get
a machine to connect using multipath with both a NIC and an HBA.  What
are the prerequisites that I should have running before I attempt to
go through the above knowledge base procedure?

I put IPs on both the NIC and HBA on the SAN network.  The SAN is
showing both IPs as trying to access the volume in question.  iscsi-ls
only shows 1 device (/dev/sdb), and it's taking the path through the
NIC to reach the SAN.  I can verify this by watching the SAN volume to
see which of the IP addresses is sending traffic.

Should my HBA show up as another device (/dev/sdc) before I start
attempting to multipath?  Or is multipathd going to link both NIC and
HBA to the /dev/sdb device?

Thanks,
Scott
