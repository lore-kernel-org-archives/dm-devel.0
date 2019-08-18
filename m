From: Salvatore Bonaccorso <carnil@debian.org>
Subject: Backport request for bcb44433bba5 ("dm: disable DISCARD if the
 underlying storage no longer supports it")
Date: Sun, 18 Aug 2019 17:59:41 +0200
Message-ID: <20190818155941.GA26766@eldamar.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Chris Hofstaedtler <zeha@debian.org>
List-Id: dm-devel.ids

Hi

In Debian bug https://bugs.debian.org/934331 ran into issues which
match the upstream commit bcb44433bba5 ("dm: disable DISCARD if the
underlying storage no longer supports it").

This commit was CC'ed to stable, but only got applied in v5.0.8 (and
later on backported by Ben Hutchings to v3.16.72).

Mike, I have not checked how easily that would be for older stable
versions, but can the backport be considered for versions down to 4.9?
Apparently Ben did succeed with some changes needed. To 4.19 it should
apply with a small conflict in drivers/md/dm-core.h AFAICS.

Regards,
Salvatore
