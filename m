Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2E3262B1
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 09:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UW/7/nu4"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D06B41FE17;
	Thu, 26 Oct 2023 09:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698311564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WVRag2D80J+IvtVEXlzq3gq+GKTuYz8g/8LC6FdwBQc=;
	b=UW/7/nu4GqY4octQ2QN0q7hveKVxgTeLzK568maHUk60m9XLwl4BHASPYTtyQvMKF0IOb4
	E6HCCzHbCeDkOryqPzjr8NJ5VGaTezMmJTUqYuL/BX/cEotNobKQE161GS8GLSR2h7lxAf
	fRO0kOedaTtKb+eh80iEpXGyVwhvYvg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 93A0F133F5;
	Thu, 26 Oct 2023 09:12:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id UHZoIowtOmU5JgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 09:12:44 +0000
Message-ID: <2841b374d6c8cd2906cdd22410bd83d3ce56c520.camel@suse.com>
Subject: Re: [PATCH 3/6] libmultipath: io_err_stat: don't free aio memory
 before completion
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
 dm-devel@lists.linux.dev, Miao Guanqin <miaoguanqin@huawei.com>, Li Xiao
 Keng <lixiaokeng@huawei.com>, Guan Junxiong <guanjunxiong@huawei.com>
Date: Thu, 26 Oct 2023 11:12:43 +0200
In-Reply-To: <ZTmlwx5VYxwexaVd@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231024164937.14684-1-mwilck@suse.com>
	 <20231024164937.14684-4-mwilck@suse.com>
	 <ZTmlwx5VYxwexaVd@bmarzins-01.fast.rdu2.eng.redhat.com>
Autocrypt: addr=mwilck@suse.com; prefer-encrypt=mutual;
 keydata=mQINBF3mxsYBEACmOnQxWBCxCkTb3D4N8VAT8yNtIBZrmvomY7RLddBIT1yh2X7roOoJQ5KlmyjMmzrPr111poqmw8v4dUqc1SVqQoKHXv97BzlVIEKC5G2W29gse0oXhx3dhie0Z6ytkHVOY29VLsLhVXEz+p5xL71KYgIy3lmM/NaWvoqwwaXiv1TmLG96Uoitvj1vdXqqTv/R6/MBye+xQUacXpM8FA5k7OpmzCFjl4NVtGmo0VhIfXM/ldmyEJpg8a5LrZ4t5Qi32BWQjUHGmS8OXjUJ/n0QxLkymbcbY1KepP9UnLGPT+TmKJm1QlMDj69+WPKgMsif3iz4hZPoQ0Knp11ThYzBh7+AiRxE9FG2hTtZeKimkpjR12bytF4Y0aIM/HeLMHRvwykJuh5JxT9A68xF7hmqQZ7rsx/GoRBOA792kFgr5KdCZ1YoeVUkrohT1nfh/Y/Xfeq4E69mktE0R0Yxg/4CSiB7sLSzry8dyqk2sbGs+W/Ol7D7VOG45aZ5iTB08R2ji2xKArcH+Dmy48nwqIvdrppZG2tZEe+wtGPTzahE4OJdpZ3vS4ujdChynS47DVWa5JtBxfqopr0rPGoCyxmyvzJzHAUjlp7iSXpDZqfdu7F4HAC13mS41IVk/yHTXE28AKrZ4O+efZ6qgw5zJV9lAbWM7JjfdrTd+ofOc+GurQARAQABtCRNYXJ0aW4gV2lsY2sgPG1hcnRpbi53aWxja0BzdXNlLmNvbT6JAlEEEwEIADsCGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQR1Dq1LLt6xpUXU9fRnxYbmhVaXVAUCXebHhgIZAQAKCRBnxYbmhVaXVJ6+EACa5mbuH1dy2bKldy+bybUe4jFpJxflAPSrdpIlwkIfD/SgQRWUUm+BLLJMGJFSKiVC6oAHH6/mo3gdWAqBJ0LAOQDDR2BW31ERYqQQ7m01INQIvMlg+PXQ8HbWd
	CNF1SOgjxiIs04DlB+u+DD5pgPtxKFN/jaJSx9oZ+GZpSd+eJeull3a+U/1+QpYmLbH34bxYZ16+cXfarkH3QQC65DH/iIZwcpxp+v/zrQVXnsZ81XmmbLD1vMkFCIU0ircIcaJoqloNJOA46P4mj9ETwC5OiSTs7vlyHP4Ni/86kmjmr41d/baY1cAXpAbtOGYd5K72B6qSP5EJI+Ci6rSbWInQaYzKuAOrDDyhW7ODd+hOtBcmUIH5GpKvzRjdfxEP/zlyecBszxycz7lOYNx86QWsyyRWITKzHzhdqKVZ9kvjVozTtcpb1RSqsj43qqMEQjcp1uXhbmwVmbzsWaPqmCx4xsIQoXfIzzffvw+nOiPLkxzGczprwNJasDUM1hcyEPv+5VzZpE4YjlDw/mtTayehb2EGzt2RfZIuPCBr88KlWUh2+nu9RfBJNdJ2vZ13Aun8NbqPKR2vfsE+BUJY14Ak9ZIzcyruHBHQ78dxD0J+HSC1bm9e4UOnW0PBbZwuPTRwyO3aXoExPabGgig6gcY34bsXvW9SDwOu+pzXMnVvbQeTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+iQJOBBMBCAA4FiEEdQ6tSy7esaVF1PX0Z8WG5oVWl1QFAl3mxz0CGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQZ8WG5oVWl1TdsA/6A0DZmGwreygUic5csLSLUm2ahdat3rRKfQVdlOdl0aWa/vS90PqpuDNGzXVzS/s4YXRjWesnYEdwQGSc4PnBYCitLKUwenII39RCyZLU3J95luWG2eOagFaerK+HvuNEH6RpYkqPpaDEwpblfi30xNNYLIR4HK0GTYwhbmBTrYgaKATNiplU08ZUvC23s00t2i7SBGmOue/0dIPMhO3EDYPP0RaDnKvHAOAywkI1J9Ey0xEslG9AFylOihcdaq9/7MlMWU8oNHK7EVE5OOZ2NiJv1sWSgM
	6dvGdfgLeNmsiyHGDtfXYFw32e59ShkxUDc/uLLseISAftDYdPzKXxdkxRfjLkLk24HMP+uEauH0ytdC7P4NJmDHKlKH9da7lA1x94XEsn+ZMiqFvXh4ce2SgqnH7FjctNPamek+3tJIBBoFkMeABDeXnMlmLtTU21qC6lEXMLAmcyIR+eBdivTZyhf7NOE100JQYGdYTKUDITUSXdJ33cgwll4a2kUZK1nA7DGNwDYOoWF4i1cZKRBfMaD/1Pm/Los9ga/B+kfI+fQTam+gdD/crwpsr5wiXcGgggR+FwBsux3/hcoXVbBhCQKeoEE/4ajmAxsNWGZgMvRv6JLJNZ/rBfges5LjvHJY9tOcjlniJAArIfR/LrRRrQhf1zHH/fpql7lIPvBM20HU1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuZGU+iQJOBBMBCAA4FiEEdQ6tSy7esaVF1PX0Z8WG5oVWl1QFAl3mx2UCGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQZ8WG5oVWl1QWFBAAipbqrpAO+TYm8U8Nz0GpM/Q+nOya2JS2eF8UbkpZcmhC9pObpLd4PsEl6QbmDvbiVhurv5Cp7TVPhl1ap5ir7TFHvErzs4Rxwohof4MSY5SRSbYAaz4e6bMw7GGIOQhtKOXi+zzSqLrCIdTKxfNy3MYZ+Z4xBCGyE2bNExjxpDBjYrjm6ehfo8+TVabBRX+2sJsLugZszQF0tnV4Y8oAA2iePTiwSe9hz45OKEhDyNpfJ1Kg2hUropKEOS7Q+jP6Bw8M3RomQnk37GnU0Wi8wSNiyWYRhossI72Se/w1uRsQuVCT0qSsa9raLekya2rf0bPFmCBPRUP+KUrBq5yY0c6BdY45incUqhLlQo06lf38e6+CyouN0HpQ62CxQQTMxM87FRTg6uRUitWtnDLoVY/d9wgzvxBJHW4hIKuv5JNeh7PyFO7vB55DekaoRLKU3MC
	FWjq3LA0t2FLEVXdF/NcVw1Qn6kIIfbgPYVdBMO1b3ciu+NY6ba8lzqiIIH+Js/+JnAwzLQNLp360Kza7/P7bgd0NxBCbLziay7MVZawRQhCUkUWcqeonGBuSyf0wO3sFlRZm+pv1sg6I6DZCrykSFyABkH7joZg5nUuNuT3/E2Jw9gBqll6OrsgTDzWzofTASYtQIRjqLypeqiz4ADmHy9tyEt1SxVd2C4o1Jma5AY0EXebHmQEMAKL9PxzQOcH6cq2l5LhRjzvJAHwIfYTLIjtwdvuqW/AXsUKDEXVW3CNl+yavgFz0H4MrqASTisqDMIpxEZUfeZWeO8TlfPwiIyPTdXqLVxXmaPKCpT1iUZZ9QdYUvFMIxy2OOsL3wfZD7DEkj6SsA1EpSDP7wsTKcekFnqh7geur11WATHIf3Csotyp3xVqSF656KMnYq6FY1fp6xSUz2EUy2FX+VhF7FdvgxKtXEmtydiBT5RuieWhgH93oPJCTNOMAdk6MYILSXKzJriWmMvqq6Yu6m409mHpQaBBjkZEoFyjPfGGhNwc/TAplxc3tzQnlAZReCJK/0DqhgnIXbbelCM5VwzT/0w42QNi1VlDSoh0vKftWAyz8Udr1jsU5k7u6J/4Dfnugb6yzSQa4wroHx4xw59sc+OrCvH8qtfnheuWBqe6JXvzlDp+LrUsc6OqhpNWg3X2RqLXNrhEcBZPkBAdcq4YrJ66DzcKSv9sM0lvFutMe7x7FKdvPKg8RnwARAQABiQPyBBgBCAAmAhsCFiEEdQ6tSy7esaVF1PX0Z8WG5oVWl1QFAmOLw28FCQeGL1YBwAkQZ8WG5oVWl1TA9CAEGQEIAB0WIQT9/H021zOM2230IgahTsY9IAD82wUCXebHmQAKCRChTsY9IAD822P8DACHuDtarUdaBW8D/iFW26D5Ki421H/ZXN7IU0nsJgHomsIRYUxSFDFlxvLIW3HhBFZqo/M2BA1/nVg6CZey
	arO95omGf1RKu3BaGgFOQDc9NIfZ1YW4fyLu6hKgE9GFxtkFe2jPoNSNPiBhX3xpqL+69g9QcASbDAxdK76nIkbVHGXJB7NCjNo4CuDDRaiv6PDRa4GyKxdLv4FiXmX/9SfzhGgWJFUxnRwcDmNBX1CPZo2augYDFFinkz596/VecQZztgitg6sI578U7XvTZ3ZxgeOr6rfg6iDuOQUXoObfkFPFxLDxH6zRLsJn+EsTnRZN/xXFWI5XwXUlrSeXowulKKjlVzmoDU84TYr1HmbS7vDDUfr8oO3xN4/QtSxUoEnMQ1nbjFciUiXIQuZNWlngmDhooPN0hIvmr0nbgCK/W2j7CNjFk8i/htPTfn+zNr4mcikegWpCX4jNnYwPB9oiZHVmXLKFpvTx6uYXYg4zSAQH6s/OB7VwxlfJyUfxGtNpbRAAhpfIRSOwlugNrOxFyMyJkgywTBTtI0ZMhCOkeUfsx3eFkuFVgZ4RNqTzybbqGlDpVtZ3rk6pqyXG9WrcBlrfO68+7bEKuqb5bUgMqCsYv6+Pw2oTbCp3nGtJkkUIMuNqkz4L0a9sxf31/HWdPHu2z4D1QSx/YzxqcJmXU91n4ejb1QQd+VL39baJIXkzpNjzWasHph0uzV+cJM5pdAgOX0TWNhWRWQyNewlUCj2mICh8MCAUp+ISouiWDlkYaR8nQAvj/MFb8x7w06GXnYh8i4KT+osTYflT6d1lmwCDdTMyYL8YZW4THqw18uKoaKrKBzLHRh2VoAp/HUXrcqioQezj25ErLW1mGQ6w7/BEGcBqSAjAvNfYM20YN3Y4evzesiDRcqro41daeagnesHyd8iMcd6rDn1UT6iywoOHGbie9QkG1y6Cys5dpMjp9lbcTU4C/bDdQA6Bv27uJva8b7Jiu00JU8ndGFFOny3R+RY6uKTkb5Smz94n1Lakk2lxYPaSiMF4vhv4zT0f69JZMsqTG8hkyIVdUrvyuMEB57uG9PwOh
	m2DvetZObQriBdpxjQcDOD5km2MGwJBj4GWSc21uh7ETqbP8uZLwaxJYPYHZ8hO+32oUHsfN5+/+tYKCGsLgd1vchIt3i4H+yUssYieyqvKDDTH9ZXw7FLPtxW5AY0EXebH5QEMAL8O8qQiFEWZoIEKxXMOrqnnR1sv+pIiH1+31s+LxhR1rw0JKyYFnJE+0yqoQJCi7HjG2xKDBglhlGfWw4uAPB6ZrIbHcRqhiUHmTYWvwANhiTC3Ibp68YNGGiB1W4YQaiBN3Bbcx4Gqo6UVIUS8H6i5anA7zLYdnTteY1UCXm8qc3rWbUaEZIZkcNpM3gyGw8XJFCWoY4yifL8Rzwm+Gi+mn8xmkoRHoYxlKtJDwtodNsJOCWLEY+I8BMrKmZyteiquO7eQSup0ONgJTyTU0HAsoCws/imjK5RZoCKXUNMJr8KOSjG1fTGBZd3/KwFFRNqJOMtx3KAxRu5WjQaArGrjIIjT/F/lG6nyRZ1T7z/JaWehRcA1jnWG4SnQzo/qzldUEUnLjIrrIbM31UUNDXCMCg03OgNwOc9O2SYbosMWo9ek4iry7rr3WsDdi4oTz/O+q4hzb7Gd7oX/bCGNIbLgIyce6cjPqD/Jjg879j4SRcUau2XjdziCGfKFJRCTTwARAQABiQI8BBgBCAAmAhsMFiEEdQ6tSy7esaVF1PX0Z8WG5oVWl1QFAmOLw4gFCQeGLyMACgkQZ8WG5oVWl1Q5hw//VEBRtoTabcV2GqykzHjk3QlVPyBYscdmfY0N/gd56zc4BoiHaLWWVEGBi3YAi8UAE3TVPYGDFU4bRcOeKzcmPwvb64ReGtOZzqB5ga0vSdmFR4PoSRMhuH8Dd3+wrpnF3NoW+Jd2Mu1pY9gJDTnW3wzvAlgzoO9WgBsACMrtYN5LKT3mGXtiztZYyZmrIbKXC2hIrf20uVC5SuZ6qZTeTVLJdUok+0ZmFRj01pJl1fLpyk5+Vrok6Ex3fqza2Fequc
	glH14N9+AviBllGIftz7lOwelwU/EJn8oSpzxDx5+yhQWglpqVxktYnQ36IQsFNvvuHC6HeZ6jqgmLbK+jnWM3RLX2tRcCKzRnLKOzlT2CMS599tNTA0DQQu89IgKRA/5DL0pZQOS4p7HNfYA/9fT1mIW34v3J0WK9t/XvH6luUSRjGX9mFhs/isOm5MbA5brLCtp++fnpEXxVskW+QX6Z0Q8/LwNjpiGY+oYZfd17hGeC2CtmRr4HcqRBw6pHgqhPzLVVGsvFgMjIm3iNSPrPn7i1nJa3+Q99gqmln+iyVgVZ8oMDBFOf0fdBjSdL9Lig83T9Uj5bpe6uEd2oVjaApu3G7KOvNDiD4IzVX8kRgbIiv3jvO0p4bExhrjEe28tO1G/w/grfGtjoXC6KXxQS5jk4X9zALShvo4tOlS65AY0EXebICwEMAOtx5vY5VtPL2VucF0ypZqqUnfVevJ12hhsjkbJ5KPc07SilwKmZsfujC0Fh68zKTEMup2b4O3kQHV/w7l+flH878NlWA/TdE/iSQXnrM3iCve1J0dKWGKSPvuqtt2/h3xOPLIZQPdw+2otNFyxvuHGQq75Dfiu/e5kNi3hprdXuOgqCcmkXrXTIm83cBr7CvsWE1yxXuelC0UV2m1O7P+9wJkZ3/mdrXp6KYj4OknBAT/fRoBKscW9xbOXnY3I6DnUK4z6y+rL8l+vdrpfYtprF79086YL0wGOWlCJCf2WoVo5zmb9nCSG0rU9tWJR9qTJ4ctIoZXzSeK1r4f6XiJnnBHFWe4lsl02TuF3VP3WCBnplxeb6ULnL+NHk9YzpOtz03W+P7OE5pvg3GR+IO5qHTlsIO4t4mXQ3qP+adjQYWwyLP3fvqrbpMroa62gjTfCH4jPUxMmxmuW++cmemmm/S5q5qixp6oayN6C8YYzEB2lKZGZfX8QpgVLFZyMyfwARAQABiQI8BBgBCAAmAhsgFiEEdQ6tSy7esaVF1PX0Z8W
	G5oVWl1QFAmOLw5MFCQeGLwgACgkQZ8WG5oVWl1RcuQ/9HP1UF+ZV57SzCf1eS762xvxqndgOzfOF9FNdRe6oSFopq/w/gEV7GxJFlgip2OQU7gq6wNGoMIHMT2v1sb7fGgR6yuYdpIWRtAlBdgqE6uTXkudEdssVF6pdMZOM6fBgoiO5mRu8wdhjkgE2nWcuSLVCPMfY7u9ouX1nTTH2Z0BZUilHdQrZU1dSj6eIXgfzUhwN6Ne8Fql9n12yfvcDATtjfFcjXCgnsa9JdzzICqXw76wZaKt1BDbKkTjI/aqqtlxQXeaGbP9wNFdHWLEhAQR/ICHwpMJ0Hm7lc2Zf7P+n/LtfZ8mE7wsPZsjcugxT12mM6B9AaGX9qPSpc4kPsFrzRJuGMTq328BRPoakJvDLGC2Q8L8aP768EC5sDcGTBKtm7BpkTAl33q5uJFJW5CFZpBy683DKdFk4gsfn5Ni6eCAia3Vup5N2b7DVyi7pxJfldUyICLX6CEmPx0q/bQDn130Xvk7hYYMXy2In76h3tifVcxps6IQx8Ynbi+QaeY+cwBbiYy6PYcEt59mSgbCWCkIZxyLhcK+6SCzJ7BCalnmV3P9MCyfaJNrY+Wtgq2TiScMCzXSGPOZfURAkVCYt790yyWDnKmV45LJRZziCadR0bMxqc65ZTOdfIhgec3you+KszeTlS0ipA98GAhczom1VKAlTmB2+Lt2u3p8=
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -7.10
X-Spamd-Result: default: False [-7.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 RCPT_COUNT_FIVE(0.00)[6];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO

On Wed, 2023-10-25 at 19:33 -0400, Benjamin Marzinski wrote:
> On Tue, Oct 24, 2023 at 06:49:34PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > It is wrong to assume that aio data structures can be reused or
> > freed
> > after io_cancel(). io_cancel() will almost always return -
> > EINPROGRESS,
> > anyway. Use the io_starttime field to indicate whether an io event
> > has been completed by the kernel. Make sure no in-flight buffers
> > are freed.
>=20
> There's a minor issue I mention below, but the bigger issue I noticed
> isn't related to your fix.=A0 It's that, unless I'm missing something,
> we're not using libaio correctly in this code.=A0 We call io_setup() to
> allow CONCUR_NR_EVENT concurrent requests. But we could have up to
> CONCUR_NR_EVENT * number_of_delayed_paths concurrent requests. The
> easiest fix is to create an ioctx per delayed path. However this
> would
> mean calling io_destroy() after each round of testings, which could
> potentially stall this thread.

Right. I suppose what's going to happen is that io_submit() will simply
fail with -EAGAIN. Note that the code logs io_submit() errors only at
log level 5. I guess if all goes well, the aio requests will terminate
quickly, and the algorithm will still "work", sort of. But if timeouts
happen (which is what this code was written for), the iocbs will be
quickly exhausted, possibly with IOs from just a single path, and
other=A0paths won't be checked at all.

Btw, it's kind of odd to send 32 identical requests (all for block 0)
to the same device basically at the same time. I would think that with
very high probability, all IOs will either succeed or fail. The IO has
no FUA bit set, so even if it's direct IO, I assume that the device
will answer all but the first request from cache. I understand that
this is supposed to detect marginal paths, but it would make more sense
to send these IOs in random intervals than all at once. But maybe I
misunderstand something.

I've added Guan Junxiong, the original author, to the recipients list
of this email. As a first remedy against the iocb starvation, I suggest
to simply allocate a significantly larger ioctx, and increase the
loglevel of the message indicating io_submit() errors. I'll add a patch
to this set.

> =A0
> > Fixes https://github.com/opensvc/multipath-tools/issues/73.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > Cc: Li Xiao Keng <lixiaokeng@huawei.com>
> > Cc: Miao Guanqin <miaoguanqin@huawei.com>
> > ---
> > =A0libmultipath/io_err_stat.c | 26 ++++++++++++++++----------
> > =A01 file changed, 16 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/libmultipath/io_err_stat.c
> > b/libmultipath/io_err_stat.c
> > index dc1c252..c474c34 100644
> > --- a/libmultipath/io_err_stat.c
> > +++ b/libmultipath/io_err_stat.c
> > @@ -111,10 +111,14 @@ static int init_each_dio_ctx(struct dio_ctx
> > *ct, int blksize,
> > =A0	return 0;
> > =A0}
> > =A0
> > -static void deinit_each_dio_ctx(struct dio_ctx *ct)
> > +static int deinit_each_dio_ctx(struct dio_ctx *ct)
> > =A0{
> > -	if (ct->buf)
> > -		free(ct->buf);
> > +	if (!ct->buf)
> > +		return 0;
> > +	if (ct->io_starttime.tv_sec !=3D 0 || ct-
> > >io_starttime.tv_nsec !=3D 0)
> > +		return 1;
> > +	free(ct->buf);
> > +	return 0;
> > =A0}
> > =A0
> > =A0static int setup_directio_ctx(struct io_err_stat_path *p)
> > @@ -164,6 +168,7 @@ fail_close:
> > =A0static void free_io_err_stat_path(struct io_err_stat_path *p)
> > =A0{
> > =A0	int i;
> > +	int inflight =3D 0;
> > =A0
> > =A0	if (!p)
> > =A0		return;
> > @@ -173,8 +178,13 @@ static void free_io_err_stat_path(struct
> > io_err_stat_path *p)
> > =A0	cancel_inflight_io(p);
>=20
> There's not much point in calling cancel_inflight_io() here, since
> since
> we don't try to handle the done events afterwards, is there? If there
> are unhandled ones, they will remain unhandled, and we will end up
> leaking memory regardless of whether or not they're cancelled.

You're right. I'll have a closer look.

Martin

