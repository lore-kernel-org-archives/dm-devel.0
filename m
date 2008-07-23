From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: RE: Losing paths
Date: Wed, 23 Jul 2008 09:12:43 -0400
Message-ID: <1D80D4F6D179BD4D869FE807A5BF833602D8B686@EXCNYSM0A1AN.nysemail.nyenet>
References: <E6D1DDD48426A44EB25DF27F5AAE7A6505B96AC7@KL1010XG.cs.ad.klmcorp.net>
	<AB48FAA97D916742945DE3B0C9AA521B0276FB5A@KL1010VE.cs.ad.klmcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
In-Reply-To: <AB48FAA97D916742945DE3B0C9AA521B0276FB5A@KL1010VE.cs.ad.klmcorp.net>
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

Did you change multipath.conf and reboot the machine?
 if not reboot, what steps put the changed multipath.conf into effect
for the 2145's (SVC) LUNs?


--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.


-----Original Message-----

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Koehler, M - SPLXM
Sent: Wednesday, July 23, 2008 8:34 AM
To: device-mapper development
Subject: RE: [dm-devel] Losing paths

Greetings,

We tried testing with path_checker readsector0 end directio but we get
some strange behavior eg the checker used is always tur!!
So if we create a device entry special for IBM 2145 and define as
path_checker directio or readsector0 we still see in the message file
tur messages:

Jul 23 08:09:00 kl11071i multipathd: 65:0: tur checker reports path is
down
Jul 23 08:09:00 kl11071i multipathd: 65:16: tur checker reports path is
down
Jul 23 08:09:00 kl11071i multipathd: 65:32: tur checker reports path is
down
Jul 23 08:09:00 kl11071i multipathd: 65:48: tur checker reports path is
down
Jul 23 08:09:00 kl11071i multipathd: 65:80: tur checker reports path is
down
Jul 23 08:09:00 kl11071i multipathd: 65:96: tur checker reports path is
down
Jul 23 08:09:00 kl11071i multipathd: 65:112: tur checker reports path is
down


Oure multipath.conf file is:

defaults {
        user_friendly_names yes
}

devices{
      device {
               vendor                  "IBM"
               product                 "2145"
               path_grouping_policy    group_by_prio
               getuid_callout          "/sbin/scsi_id -g -u -s"
               prio_callout            "/sbin/mpath_prio_alua %d"
               path_checker            readsector0
               failback                immediate
       }
}

Did someone see this behavior before? Or are we doing something wrong?
We are using device-mapper-multipath-0.4.5-27.el4_6.3 on a rhel4.6
system.

Kind regards,
Menno=20
**********************************************************************
For information, services and offers, please visit our web site:
http://www.klm.com. This e-mail and any attachment may contain
confidential and privileged material intended for the addressee
only. If you are not the addressee, you are notified that no part
of the e-mail or any attachment may be disclosed, copied or
distributed, and that any other action related to this e-mail or
attachment is strictly prohibited, and may be unlawful. If you have
received this e-mail by error, please notify the sender immediately
by return e-mail, and delete this message.=20

Koninklijke Luchtvaart Maatschappij NV (KLM), its subsidiaries
and/or its employees shall not be liable for the incorrect or
incomplete transmission of this e-mail or any attachments, nor
responsible for any delay in receipt.
Koninklijke Luchtvaart Maatschappij N.V. (also known as KLM Royal
Dutch Airlines) is registered in Amstelveen, The Netherlands, with
registered number 33014286=20
**********************************************************************

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
