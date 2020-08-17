From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH 2/3] IMA: add policy to support measuring critical data
 from kernel components
Date: Mon, 17 Aug 2020 19:43:18 -0400
Message-ID: <97d25609b6a87f104cc88a2ff8ae52d3f2e4e387.camel@linux.ibm.com>
References: <20200812193102.18636-1-tusharsu@linux.microsoft.com>
         <20200812193102.18636-3-tusharsu@linux.microsoft.com>
         <591b5f09c7df8ef0378866eaf3afde7a7cb4e82f.camel@linux.ibm.com>
         <5275268e-2ce8-0129-b11d-8419ac384262@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <5275268e-2ce8-0129-b11d-8419ac384262@linux.microsoft.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, nramas@linux.microsoft.com
List-Id: dm-devel.ids

On Mon, 2020-08-17 at 15:27 -0700, Tushar Sugandhi wrote:

> > scripts/Lindent isn't as prevalent as it used to be, but it's still
> > included in Documentation/process/coding-style.rst.  Use it as a guide.
> Thanks for the pointer. We'll use scripts/Lindent going forward

Please don't change existing code to conform to it.  Use it as a
guide/suggestion for new code.

Mimi
