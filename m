From: lemons_terry@emc.com
Subject: Linux utility to determine WWN from a LUN number
Date: Thu, 13 Mar 2008 15:32:25 -0400
Message-ID: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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

Hi

I want to have multipath manage only the CLARiiON LUN that I boot from (L=
UN 0).  So I know that I can specify the following in /etc/multipath.conf=
:

blacklist {
	wwid *
	}
blacklist_exceptions {
	wwid nnnnnnnnnn
	}

The wwid value is different for every CLARiiON LUN.  So, if I want to aut=
omate the process of adding the 'wwid' value to the blacklist, what utili=
ty can I use to specify a LUN number, and find the WWN of the LUN?

Thanks!
tl

Terry Lemons
Backup Platforms Group
EMC=B2=20
where information lives
4400 Computer Drive, MS D239
Westboro MA 01580
Phone: 508 898 7312
Email: Lemons_Terry@emc.com
