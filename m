From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [BUG][next-20170523][Bisected cf22cd5f3a] kernel oops while
 running trinity fuzzer
Date: Wed, 24 May 2017 13:23:35 +0200
Message-ID: <7f7d021c-5116-3a04-b4c0-decacb26d80f@gmail.com>
References: <1495618157.9020.24.camel@abdul.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495618157.9020.24.camel@abdul.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: sachinp <sachinp@linux.vnet.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Mike Snitzer <snitzer@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 05/24/2017 11:29 AM, Abdul Haleem wrote:
> Hi
> 
> commit cf22cd5f3a: dm crypt: add cryptographic data integrity protection
> suspected to be bad.

Isn't this false positive? That commit changes only dm-crypt and that module
seems not to be even loaded...
(Moreover config has disabled block integrity so this code should
be mostly compiled out.)

Milan

> 
> Test : trinity
> Machine : Power 8 (LPAR)
> kernel : 4.12.0-rc2-next-20170523
> Config : attached
> 
> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc0000000015d8824
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=2048 
> NUMA 
> pSeries
> Dumping ftrace buffer: 
>    (ftrace buffer empty)
> Modules linked in: bridge nfnetlink rpadlpar_io stp llc rpaphp xt_tcpudp
> ipt_REJECT nf_reject_ipv4 xt_conntrack iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
> iptable_filter vmx_crypto pseries_rng rng_core binfmt_misc nfsd
> ip_tables x_tables autofs4 [last unloaded: bridge]
> CPU: 4 PID: 2474 Comm: trinity-c4 Not tainted 4.12.0-rc2-next-20170523-autotest #1
> task: c0000003a6ae2500 task.stack: c0000002bf7ec000
> NIP: c0000000015d8824 LR: c000000001ef855c CTR: 0000000000000000
> REGS: c0000002bf7efb00 TRAP: 0300   Not tainted  (4.12.0-rc2-next-20170523-autotest)
> MSR: 8000000000009033 <SF,EE,ME,IR,DR,RI,LE>
>   CR: 44002841  XER: 20000000  
> CFAR: c0000000015d8810 DAR: 0000000000000000 DSISR: 42000000 SOFTE: 1 
> GPR00: 0000000000000001 c0000002bf7efd80 c0000000033d3600 0000000000000000 
> GPR04: 0000000000000000 0000000000000000 0000000000000000 c000000003743600 
> GPR08: c000000003743600 000000000006d123 c000000003773600 0000000000001000 
> GPR12: 0000000000002200 c00000000e9c1600 0000000000000000 0000000010035e80 
> GPR16: 0000000010033950 0000000000000000 0000000010033a50 0000000000000000 
> GPR20: 0000000010985cc4 0000000000007d9d 000000001001bae0 00000000000185f8 
> GPR24: 0000000000000000 0000000000000000 fffffffffffffffa ffffffffffffffea 
> GPR28: 0000000000000008 c0000003a8c48850 ffffffffffffffea 0000000000000000 
> NIP [c0000000015d8824] memset+0xc4/0xfc
> LR [c000000001ef855c] memzero_explicit+0x3c/0x70
> Call Trace:
> [c0000002bf7efd80] [0000000000000008] 0x8 (unreliable)
> [c0000002bf7efdb0] [c000000001e3fb30] SyS_add_key+0x1a0/0x410
> [c0000002bf7efe30] [c00000000152b7e0] system_call+0x38/0xfc
> Instruction dump:
> 41820038 409d0018 f8860000 f8860008 f8860010 f8860018 38c60020 409e0010 
> f8860000 f8860008 38c60010 409f000c <f8860000> 38c60008 2c050000
> 7cb01120 
> ---[ end trace c454dcc1309b8479 ]---
> 
> 
