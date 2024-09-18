Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0066A176230;
	Wed, 18 Sep 2024 14:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726668341; cv=none; b=f8P/8Su7c4Z0K2FNxh9Q/rYWh/cs+jhl0wOQcnSoTKRuj37nLAFkhyf2TGLlBgBhAl+oPvbWR0iz9HqNvYa0R7syEuDso8D+CC8yGP7qZeHpaUEgLz0RSjH11ExKB8PuNzuUQzwcHua6yZBBDKN0afizfEYS60DHgN4hlER+NO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726668341; c=relaxed/simple;
	bh=6zBAQ17LZQR9zBcfVlgt0Uw/0T/zok1IojabaDHGmvE=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=DhoWes8TdltocBCEtD7bEfm2aI5uSa2VmPrOlo88SrCzkj3Odc4TX4iTcBTCHpLfbX8o8n6ufTwM0S8g+0MtqHX2k73krjy9lVstJITvv9bAbs8hB0uczcL/3fTkfc/qY5lwd1BPLrM/s4qEQSOUGJVNvbssuc41uPrT1ZXWbFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=mrshMlgt; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="mrshMlgt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1726668326; x=1727273126; i=markus.elfring@web.de;
	bh=183N5FFu+mvhtVZf8+8emO6n1S0+rQzAD7UWVL5EAn0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mrshMlgt/yXyEnm4CVa5vshO1ikrs7mngi9nH7AgL59jIXT9SzwZFc6hLHuctWKx
	 p3vCvxqZSUi3MnVILE3ebMX//Kl1sJbkbN6r7bqbTVNNRXiCJNRMD3ncKxLxG8jLb
	 CIn2J33Wj0miJ9l5nI+Gk9PzjcWHDlY1fYswQ98jlCZ50Zv91w/5Qg+a+a+Q+pvAx
	 tyZktCtrUrpZNktbQ5ptieBOdImCEMTNmm4OSkcbvRJFsnnZGAuFfJnyIPTZgWNHc
	 XYBVvK5yKY4+w29Z+Laewy7DwaT6nATikLQXIVq9neoZ81bBH+VmnLqKgssuFc/G3
	 w89MpdDfitiN9FPBLA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.85.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MCoku-1si9ri3Ajg-007UDT; Wed, 18
 Sep 2024 16:05:26 +0200
Message-ID: <68ee5a00-888c-420f-a3a9-a556c19ee6eb@web.de>
Date: Wed, 18 Sep 2024 16:05:22 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: dm-devel@lists.linux.dev, kernel-janitors@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Ondrej Kozina <okozina@redhat.com>,
 Waiman Long <longman@redhat.com>
Content-Language: en-GB
Cc: LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH 0/2] dm-crypt: Adjustments for crypt_set_keyring_key()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wZPZJzhPw2YNK/b7ALwOzH9Z/GxeCgmAbFC720VQttf8jZzkZo8
 v0JG8GUsAMy42/ayyVzX19oQSVIkfUXMTQkhGXbYc/R7KNQcRRt9/LL/p4fKGhFpHj2C6j6
 IJL/OXSV7PPmMERnbhPQ6F2A8uyXnXXG6eVrxj12ZR95aU8LcjdJamRYjTrj6BOnkA4Zidv
 WqfQ9Wih1GFn07TK8aS9A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:SKQMyh4ffik=;8mcWZ3wwSzu9PyfdykXM1fsG+cg
 OOaCTMgIv1OEa2lyzic10kTaGdAE9WPXtHYT7BEfAA7Frkh/psVmVzY434xvCHKmkB3hHAsGK
 wiDXAfbIqhTJD0B8XTb7qmigEEs8g1Yl0k8B1OpQSX0m8NawiAGYrFRePWRA95TqXit+slJYd
 PqkxkwLF7CDJGIPkrSnisoKykt/u7UbYNNVetEzGJMUtzJLIwAvoIsmxgE5F9QynTtuIbwwm9
 noC6hcBl2IKkGwXxq64bu1gykz15Qe+zC6hLHiZWk5c/540Le9e95NNgsR3A4hdYrjGC10lP3
 WO7j5gntKeRHtxzj5kXc6AzPuqMeiRtEE4zP5iwv/JiIenvEIloGGMmLLWB/7a740XMNYstJB
 4yB7glDKzQsQjvWjLf2nhpEXCHb3u1aAx44INICq/5TqN7oev9zJlzaDbWL8Wc8xhVFwlYARm
 FQfu9QgUuLODoFtvMOkKU0N6ZoXai745xSWnTxVQBGmICXk7shNW9sZL/8Ui0vKscXKqQaHZY
 KFl5COZBrFL66PV2hjZ1T2JZyPCRYmmx6VSQysTauXLpVMr7dqSavEyVACBZXbisdU12SNHxR
 abnhHV8Baf1lplTcfnq1HGBZlXv9ZzrL7jd5S3OMMlDv7K4lzQZ8sTvZykYB/Af/jbWLf+ehG
 c0WtC+QEl3ReYs9hmBhehrJT1y7gKzdUbFLKG65yTNvQO9vL6mEcVK9QyNQkHytvSg7WvAiam
 2d9/+Ys7QyovFIoyjvkehL7sZqsWjwrYEAvI6bq/FplFvjxWUEMV2Yq9hmoVpaUuPMgh0dulf
 pRECMlO8QCXM3uHpXpIqnIqw==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 18 Sep 2024 15:48:05 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use up_read() together with key_put() only once
  Use common error handling code

 drivers/md/dm-crypt.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

=2D-
2.46.0

