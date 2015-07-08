From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: DM-Cache Writeback & Direct IO?
Date: Wed, 08 Jul 2015 11:03:42 +0200
Message-ID: <559CE76E.6020504@evilazrael.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi,

Can the dm-cache writeback cache buffer direct IO or goes direct IO 
always immediately to the origin device?

I am currently performing tests and see that random direct write IO 
never hits the cache, even after overwriting the same region over and over.


Kind Regards

Christoph Nelles
