From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: [DRAFT] Snapshot boot design document
Date: Thu, 1 Jun 2017 21:47:35 +0100
Message-ID: <20170601204734.GB3619@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

We're drafting a proposal for a generic snapshot boot mechanism, to
allow booting into previous snapshots of the system for LVM2 and
BTRFS volumes (as well as Stratis[1] in the future).

The current version of the design is available on GitHub (as a PDF
or LyX source):

  https://github.com/bmr-cymru/snapshot-boot-docs

This documents the current state of support for booting into snapshot
volumes, as well as a brief survey of some of the current competitive
implementations, and proposes new software components to facilitate
easier use of the facility and additional functionality that can be
provided once basic infrastructure is available.

The document is still under active development and new revisions will be
issued as feedback is received and integrated: we'll review the work
as we go and decide on a final implementation.

Regards,
Bryn.

[1] https://stratis-storage.github.io/
