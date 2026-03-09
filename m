Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C117838E112
	for <dm-devel@lists.linux.dev>; Mon,  9 Mar 2026 23:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773100736; cv=none; b=gWO0WB+IGg1ybSll24fOk5cHAMS3YYXyQK3YzCmqcHgtxkIF4rzxsJzRVE/SklkFKdQHVu4Glz4Wzmx2dTE5T6lmINBF4eAERpOUurWazdV3aXkR3ABbuvO1B4TtEuAEfcE90ctQxvjUJLGIjhDelOca+BP/mgfBv/XTOnmh+HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773100736; c=relaxed/simple;
	bh=40Mlp2c6INEworHVA8B/tjgxxnGjEAtQ2cBtMbRWvDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ti5xOLs0Ncl8NVPDIgZWJOSjbqoPz80ZC6dow5EAtmysYlhdcOFMr2qCcaIJTv/KuLE1upBP8zT+tSzAhHNeD9IXNaf6KKW1XlRXY2+56puaf5cd0/Na43IBwt27dq1SPfEw1RLkPCp4Y9J2ZvQ7nLPQxOCDVcbNGZtSx1P2HdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sung-woo.kim; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sung-woo.kim
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8f9568e074so2022653566b.0
        for <dm-devel@lists.linux.dev>; Mon, 09 Mar 2026 16:58:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773100733; x=1773705533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Oe74yVewJW4EdL4NdMuEiANgmdgDMqRgsPaxoV9IVrk=;
        b=vb6E2y2nAHvM4b/ebxt17y7iaqgQQgBHbmGkoJQjiG/DCNeD+5mQIv7GWy/Y2PLDBx
         XiiDm8pB6QybLXQiSnpz8F9auGU0Afp11mqEhNezIxslpggXQE4bfFJpIVh29/AF6ICA
         g8DtXiqSPN4439Z13jdvYODQvqEBHhfo/RZW9tMNBkvFDxXpwAK4cFYrEQABlVhiwUie
         s+CFe8gchWuYQnKi4TTW/on+6S8sQhRQzair4fzQReyVEIFbTzYsThbh/LH2eQP4mmk0
         TWP5YYYktvh605Zg+xkGzwi1vMUpZfX08AKyqifv3EQ+CYdtGcULErr+aO5cQv3vlBtN
         w2bA==
X-Forwarded-Encrypted: i=1; AJvYcCUh3g1i1IJL3nZ7HwVMho5I/K/7YMHU8jONUx4CQkxuyLvPlJMeIVuV7qbZ39+s4KSkiTsMR/Vqxw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxGzxdzfO4oxW6OlSOxe1P7BJ0+8lSf9iEt6FE1c5ynRoXscA1F
	3LlZVAxTYB2m2S03SPZoG2E45uNnRped0WsO+5lRzSe65P5badGnfVqEHyRwSVeh
X-Gm-Gg: ATEYQzxy+MxUWUkZVJEzp2qz5irtho+u+sNaKiCEkWAkD/p3XdwcST/hBKlV5IpArLR
	wqe7D/GOMW5lH8ba+YSFbS/x3emM4zHoqxXzCvxfx82koDgAjVHYEFZldVEq+h9utPddURWF9Vb
	P4fGtP1wfEiu35KI1FI2AZFy1PzcdTctU7uE2SSMG9378pL9d3UFPaqzk8+7XcGKvXlqlAg2iqP
	BXSOajMYy10vlZYRZHPlSZvlcjsItHA/JON3Jo7ogd/MQZjGW+1nrFhthVXDh9dnXEazf9U+O1J
	+6YxWBe54hm9UsxWX3xnRE0d1tg9m966tUVf+1H2uYnNEvqBafB6pJysa+6z5foy/P3HBN00INs
	gPirXJz1Nk7Fs+Fo494GztGegzb/MqEEuwWcVykuNeKE5IAJuIkvvNpkvRCi12c2xDxK8IV6NGV
	7LVAHV1Lo5uhpJSzecAkBRAyP2e4+zmS46JOJE/QpjLZfkPqoqMm8zn6k=
X-Received: by 2002:a17:907:86a2:b0:b88:5a44:fe27 with SMTP id a640c23a62f3a-b942dfb204fmr787058766b.42.1773100733084;
        Mon, 09 Mar 2026 16:58:53 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942f139d2esm437186266b.37.2026.03.09.16.58.50
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 16:58:53 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-439b7c2788dso6288583f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 09 Mar 2026 16:58:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW3EAp7rP+sfIPLGesSuKTrlTVnn7Syyt8YWbE1Klj3q/6W18PyPLAcG0izu5yD1U/blGVOzZfalg==@lists.linux.dev
X-Received: by 2002:adf:f4cb:0:b0:439:df33:827f with SMTP id
 ffacd0b85a97d-439df33828emr14050045f8f.10.1773100730271; Mon, 09 Mar 2026
 16:58:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260309062840.2937858-2-iam@sung-woo.kim> <202603090911.0DdOwjTR-lkp@intel.com>
 <CADUfDZqBZWwy+6XOde_aZTwLisRP8j5qRqB6X_EJJPr+wmdGZQ@mail.gmail.com>
In-Reply-To: <CADUfDZqBZWwy+6XOde_aZTwLisRP8j5qRqB6X_EJJPr+wmdGZQ@mail.gmail.com>
From: Sungwoo Kim <iam@sung-woo.kim>
Date: Mon, 9 Mar 2026 19:58:34 -0400
X-Gmail-Original-Message-ID: <CAJNyHp+a8FqB7Y8DobMxKOn9KAQXH0KvHTRgTjFuMppneSznvw@mail.gmail.com>
X-Gm-Features: AaiRm50FODLuR7mIvmUavdQJgpvkliqN2c7Myo_nPa5e2Uo34ON5h-NAjYa6-ys
Message-ID: <CAJNyHp+a8FqB7Y8DobMxKOn9KAQXH0KvHTRgTjFuMppneSznvw@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: nvme: Fix general protection fault in nvme_setup_descriptor_pools()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: kernel test robot <lkp@intel.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	Ulf Hansson <ulf.hansson@linaro.org>, Richard Weinberger <richard@nod.at>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, 
	Alyssa Rosenzweig <alyssa@rosenzweig.io>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, oe-kbuild-all@lists.linux.dev, 
	Chao Shi <cshi008@fiu.edu>, Weidong Zhu <weizhu@fiu.edu>, Dave Tian <daveti@purdue.edu>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nbd@other.debian.org, linux-mmc@vger.kernel.org, 
	linux-mtd@lists.infradead.org, asahi@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 9, 2026 at 11:31=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Mar 9, 2026 at 1:42=E2=80=AFAM kernel test robot <lkp@intel.com> =
wrote:
> >
> > Hi Sungwoo,
> >
> > kernel test robot noticed the following build errors:
> >
> > [auto build test ERROR on axboe/for-next]
> > [also build test ERROR on device-mapper-dm/for-next linus/master v6.16-=
rc1 next-20260306]
> > [cannot apply to linux-nvme/for-next]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Sungwoo-Kim/blk-=
mq-nvme-Fix-general-protection-fault-in-nvme_setup_descriptor_pools/2026030=
9-143107
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git=
 for-next
> > patch link:    https://lore.kernel.org/r/20260309062840.2937858-2-iam%4=
0sung-woo.kim
> > patch subject: [PATCH] blk-mq: nvme: Fix general protection fault in nv=
me_setup_descriptor_pools()
> > config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/2=
0260309/202603090911.0DdOwjTR-lkp@intel.com/config)
> > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87=
f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260309/202603090911.0DdOwjTR-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202603090911.0DdOwjTR-l=
kp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> > >> error[E0308]: mismatched types
> >    --> rust/kernel/block/mq/operations.rs:274:28
> >    |
> >    274 |         init_request: Some(Self::init_request_callback),
> >    |                       ---- ^^^^^^^^^^^^^^^^^^^^^^^^^^^ expected fn=
 pointer, found fn item
> >    |                       |
> >    |                       arguments to this enum variant are incorrect
> >    |
> >    =3D note: expected fn pointer `unsafe extern "C" fn(_, _, _, i32) ->=
 _`
> >    found fn item `unsafe extern "C" fn(_, _, _, u32) -> _ {block::mq::o=
perations::OperationsVTable::<T>::init_request_callback}`
> >    help: the type constructed contains `unsafe extern "C" fn(*mut bindi=
ngs::blk_mq_tag_set, *mut bindings::request, u32, u32) -> i32 {block::mq::o=
perations::OperationsVTable::<T>::init_request_callback}` due to the type o=
f the argument passed
>
> Looks like the type of _numa_node in the signature of
> init_request_callback() needs to be updated accordingly from c_uint to
> c_int.
>
> Best,
> Caleb

I will change it in V2, thanks.
Also, I may need to split the patches by driver as the cc list explodes.

Sungwoo
