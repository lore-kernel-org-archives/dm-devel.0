From: Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Subject: dm-crypt error when CONFIG_CRYPTO_AUTHENC is disabled
Date: Fri, 20 Sep 2019 17:44:34 +0200
Message-ID: <20190920154434.GA923@gandi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

I just got a dm-crypt "crypt: Error allocating crypto tfm" error when
trying to "cryptsetup open" a volume. I found out that it was only
happening when I disabled CONFIG_CRYPTO_AUTHENC.

drivers/md/dm-crypt.c includes the crypto/authenc.h header and seems to
use some CRYPTO_AUTHENC-related stuff. Therefore, shouldn't
CONFIG_DM_CRYPT select CONFIG_CRYPTO_AUTHENC?

-- 
Thibaut Sautereau
CLIP OS developer
