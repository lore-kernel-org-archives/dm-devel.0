From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 1/3] sysfs representation of stacked devices (common)
 (rev.2)
Date: Mon, 27 Feb 2006 11:09:49 -0500
Message-ID: <4403244D.2080700@ce.jp.nec.com>
References: <43FC8C00.5020600@ce.jp.nec.com> <43FC8D8C.1060904@ce.jp.nec.com> <20060222184853.GB13638@suse.de> <43FCE40A.1010206@ce.jp.nec.com> <20060222222846.GA14249@suse.de> <43FE09E1.4080907@ce.jp.nec.com> <20060224034007.GA2769@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751264AbWB0QIo@vger.kernel.org>
In-Reply-To: <20060224034007.GA2769@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Greg,

Thank you for the comments.

Greg KH wrote:
>>+static inline struct kobject *add_dir(struct kobject *parent, const char *name)
>>+{
>>+	struct kobject *k;
>>+
>>+	if (!parent)
>>+		return NULL;
>>+
>>+	k = kmalloc(sizeof(*k), GFP_KERNEL);
>>+	if (!k)
>>+		return NULL;
>>+
>>+	memset(k, 0, sizeof(*k));
>>+	k->parent = parent;
>>+	k->ktype = &dir_ktype;
>>+	kobject_set_name(k, name);
>>+	kobject_register(k);
>>+
>>+	return k;
>>+}
> 
> This code looks good enough that we should add it to the core kobject
> code, don't you think?  Also, you might use kzalloc instead of kmalloc
> here.

Yes, it would be nice if kobject core has this function.
I'll move them to lib/kobject.c.

-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.
