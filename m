From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC,
	PATCH] dm-log.c: Work with devices with hard-sector-size > 512 bytes
Date: Tue, 28 Mar 2006 16:01:00 +0100
Message-ID: <20060328150100.GD2690@agk.surrey.redhat.com>
References: <200603271546.25508.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200603271546.25508.kevcorry@us.ibm.com>
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

A couple of options:

  Retain the existing on-disk format exactly, but adjust the offsets and
  sizes used in the reads and writes to avoid the problems (pre-reading
  other data if necessary to extend a write).

  Add an option to create version 3 metadata storing the offset in the 
  on-disk header but continue to use version 2 by default.
  Update userspace code to request version 3 (via new log parameter) for
  new mirror logs by default, but still permit version 2 for new logs.
  This way, people committed to existing logs can continue to use them
  (or schedule the update) and we maintain forwards and backwards
  compatibility for people that need that.

Alasdair
-- 
agk@redhat.com
