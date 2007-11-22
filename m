From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: RE: order of preference / multipath.conf
Date: Thu, 22 Nov 2007 14:00:54 +0100
Message-ID: <1195736454.11952.4.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: paul.cote@incipient.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The hardware table is a "device" array.
This array has no precedence over the array fetched from the config
file.

The logic thus looks like ...

1) Multipaths section (in /etc/multipath.conf)
1bis) N/A
2) Device section   (in /etc/multipath.conf)
2bis) Internal default (hwtable.c) 
3) Defaults section (in /etc/multipath.conf)
3bis) Internal default (config.h)
