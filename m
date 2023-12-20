Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5DC168B2;
	Wed, 20 Dec 2023 07:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ReOHZhSj"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d3e416f303so6914185ad.0;
        Tue, 19 Dec 2023 23:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703056501; x=1703661301; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eJqWdKRl0UBq0Wj+r8chL9QmhrnrulM60eoe1tH98KY=;
        b=ReOHZhSj/CKRCE1NE8InCmbK0WaycuRe2uaqObNOtdSObW/HFZNnvSMVv5yyS1vkYV
         z4jNHSD9B46V/mgr1V0TSRB7+VJf4K3WC5tOp6VKPY9uu0lY2MK4jF5vXkz1LGWp8Fen
         cGXglxZTKCRPlBg+DalhhSPQIoye4IjGBsBlx1bq7bI931NU7BJwvgUwXG16+Iwo4Rf3
         1xgJ/qVlsDj3sMFYgVWHQNpEwKOOPGz10dEiTirqXumMz/RCNXPWSX7Bsoc4eFYbCdBV
         cyEFXcaPsAAGBdOVjlMPlWu30WtF56VfM8bm1vUpGLdZ+IrxxT+/D189JD03XWAchk8D
         RlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703056501; x=1703661301;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJqWdKRl0UBq0Wj+r8chL9QmhrnrulM60eoe1tH98KY=;
        b=fgZdHRaO/D72W8beskmbifi7vJCri4rIVDTd6b2j/xZ5LW6JJ/jWLERRrRqkuKlJsy
         tpDGXKfu4AVS0pnMrQ7oS1bLjHIFT0HQlT1Y+9ieB5hbNi/M4FwVB7cCqy/kJaJ9KGHq
         OQZsA5mt3d5GFhmy7o0YnVUsZOTZjUhQKHO8ZmpHOa6zqRofuf1s0/h2H/Z1hwRnYOSe
         B3DvQJaCg9tyD45dQXSDiTuulR0VgiosWYBWoEUXGbS9WYemzivXC0F1Wl26ZyhbDHM1
         9R+dScVHg+yR9tIZ3jCPGB5iAAmGBhf3bZFOBpW/dDj9z+gyP/ZTV1OalIWHpKRjHjF0
         hhrw==
X-Gm-Message-State: AOJu0YzAM2soUcUycwSN3XdgaOS0Epl+/CEs7dIGXyiAIuuW0AJGTVxl
	FcMBcNriMY+januRWAla9OI=
X-Google-Smtp-Source: AGHT+IH2/KQGWsEEIk+CfQb//I/X1FN9i9PYn0R8hU2YQDfX0MobECujamcRsnvnV4o1L8WIa9T7SQ==
X-Received: by 2002:a17:903:947:b0:1d3:be34:7862 with SMTP id ma7-20020a170903094700b001d3be347862mr3583611plb.9.1703056501427;
        Tue, 19 Dec 2023 23:15:01 -0800 (PST)
Received: from localhost (dhcp-72-253-202-210.hawaiiantel.net. [72.253.202.210])
        by smtp.gmail.com with ESMTPSA id m2-20020a170902bb8200b001cfd2cb1907sm22210314pls.206.2023.12.19.23.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 23:15:00 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 19 Dec 2023 21:14:59 -1000
From: Tejun Heo <tj@kernel.org>
To: Naohiro Aota <Naohiro.Aota@wdc.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"gfs2@lists.linux.dev" <gfs2@lists.linux.dev>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	"linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"nbd@other.debian.org" <nbd@other.debian.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"ntb@lists.linux.dev" <ntb@lists.linux.dev>,
	"open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
	"oss-drivers@corigine.com" <oss-drivers@corigine.com>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"wireguard@lists.zx2c4.com" <wireguard@lists.zx2c4.com>
Subject: Re: Performance drop due to alloc_workqueue() misuse and recent
 change
Message-ID: <ZYKUc7MUGvre2lGQ@slm.duckdns.org>
References: <dbu6wiwu3sdhmhikb2w6lns7b27gbobfavhjj57kwi2quafgwl@htjcc5oikcr3>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbu6wiwu3sdhmhikb2w6lns7b27gbobfavhjj57kwi2quafgwl@htjcc5oikcr3>

Hello, again.

On Mon, Dec 04, 2023 at 04:03:47PM +0000, Naohiro Aota wrote:
...
> In summary, we misuse max_active, considering it is a global limit. And,
> the recent commit introduced a huge performance drop in some cases.  We
> need to review alloc_workqueue() usage to check if its max_active setting
> is proper or not.

Can you please test the following branch?

 https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git unbound-system-wide-max_active

Thanks.

-- 
tejun
