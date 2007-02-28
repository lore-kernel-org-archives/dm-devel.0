From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: Multipath pathcheck behavior
Date: Wed, 28 Feb 2007 14:31:57 -0500
Message-ID: <1D80D4F6D179BD4D869FE807A5BF8336D34668@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

Hi list,
multipath-tools tests the LUN paths every "polling_interval" (default 5
secs) for failover/failback purposes.

My question is:=20
Does it omit testing paths that have completed I/O's in the past 5 secs?
or does it test paths every 5 secs regardless of recent I/O's on the
path?
--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.
