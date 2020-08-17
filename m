From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH 2/3] IMA: add policy to support measuring critical data
 from kernel components
Date: Mon, 17 Aug 2020 16:43:02 -0400
Message-ID: <591b5f09c7df8ef0378866eaf3afde7a7cb4e82f.camel@linux.ibm.com>
References: <20200812193102.18636-1-tusharsu@linux.microsoft.com>
         <20200812193102.18636-3-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200812193102.18636-3-tusharsu@linux.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, nramas@linux.microsoft.com
List-Id: dm-devel.ids

On Wed, 2020-08-12 at 12:31 -0700, Tushar Sugandhi wrote:
> There would be several candidate kernel components suitable for IMA
> measurement. Not all of them would be enlightened for IMA measurement.
> Also, system administrators may not want to measure data for all of
> them, even when they are enlightened for IMA measurements. An IMA policy
> specific to various kernel components is needed to measure their
> respective critical data.
> 
> Add a new IMA policy CRITICAL_DATA+data_sources to support measuring
> various critical kernel components. This policy would enable the
> system administrators to limit the measurement to the components,
> if the components are enlightened for IMA measurement.

"enlightened", really?  Please find a different term, maybe something
like "supported".

Before posting a patch set, please look at the patches line by line,
like anyone reviewing the code needs to do.  Please minimize code
change.   Unnecessary formatting changes are unacceptible.   For
example, like the "#define", below, or in 3/3 the
"process_buffer_measurement()" change from void to int.

scripts/Lindent isn't as prevalent as it used to be, but it's still
included in Documentation/process/coding-style.rst.  Use it as a guide.

Mimi
