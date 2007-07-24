From: "Matthias Rudolph" <Matthias.Rudolph@hds.com>
Subject: Re: Problem with Multipath on Hitachi DF600F (Stefan
	Bader)
Date: Tue, 24 Jul 2007 09:06:55 +0100
Message-ID: <C67364BD62907640A033D1F4094CA7B708E7D0DB@UKSPKEVS101.corp.hds.com>
References: <20070723160033.44E0B7363C@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20070723160033.44E0B7363C@hormel.redhat.com>
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


Sometimes it happens that both pathes to a SAN LUN are not available for
a short time. Because it is not possible to enable any timeouts inside
the HBA driver (QLogic) you have to handle this situation a layer above.
You can do it with the DM Multipath feature "queue_if_no_path".

I have upgraded the HDS prioritizer to version 2.00. You will find all
the stuff on:

http://homepage.mac.com/i_am_fable/FileSharing36.html

Regards

Matthias Rudolph
Country Support Germany
HITACHI DATA SYSTEMS
matthias.rudolph@hds.com
