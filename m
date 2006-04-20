From: Ming Zhang <mingz@ele.uri.edu>
Subject: smaller size mapping
Date: Thu, 20 Apr 2006 18:42:44 -0400
Message-ID: <1145572965.26292.144.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi 

I am writing a dm map module and met this issue. I need a 4K super block
for my dm device. so assume i map 1MB block device to it, the new dm
device size will be 1MB-4KB. how can i achieve this?

thx!

Ming
