From: freaky <andy_petroff@mail.ru>
Subject: Device-mapper error
Date: Fri, 21 Oct 2005 09:28:36 +0400
Message-ID: <779948346.20051021092836@mail.ru>
Reply-To: freaky <andy_petroff@mail.ru>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I've rebuilt kernel 2.6.13.4 and I got the next message while loading:
- device mapper: dm-linear: device lookup failed device mapper:
error adding target to table.

So nooone partiton can't be mounted after system is loaded. What's
wrong ?
