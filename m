From: Jonathan Brassow <jbrassow@redhat.com>
Subject: RFC::  [PATCH 0 of 3] dm-exception-store API
Date: Mon, 10 Nov 2008 16:43:05 -0600
Message-ID: <1226356985.22387.18.camel@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Creating an exception store API should make it easier to create new
exception stores.  Once completed, a simple exception store module
should be all that is needed.

These patches are preliminary.  There is still work to do, but I'm
offering this time as an opportunity to complain about the general
direction.  Basically, things compile but that is all I've tested.

If it's ok with everyone, I'd also rather have 'dm_exception_store*'
structure names changed to 'dm_exstore*' for brevity.  However, I used
the longer names because I thought it would be the more likely choice.

Fujita Tomonori, the API change should prove exceptionally useful to
you... and I don't think you will need the 'message' interface to create
your exception stores anymore.  You should be able to use more standard
methods.

 brassow
