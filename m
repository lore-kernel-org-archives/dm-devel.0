From: Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] dm-crypt low performance
Date: Tue, 13 Jan 2009 16:50:48 +0100
Message-ID: <496CB858.70803@redhat.com>
References: <0ths36-dce.ln1@news.researchut.com>
Reply-To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-return-3056-glkdd-dm-crypt=m.gmane.org-4q3lyFh4P1g@public.gmane.org>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-help-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <mailto:dm-crypt-unsubscribe-4q3lyFh4P1g@public.gmane.org>
List-Subscribe: <mailto:dm-crypt-subscribe-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <0ths36-dce.ln1-b1aPebNLFEbkkoF7R9+BZ0EOCMrvLtNR@public.gmane.org>
To: Ritesh Raj Sarraf <rrs-7WuBAv+fczCJ8c2fQYRYNw@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-crypt-4q3lyFh4P1g@public.gmane.org
List-Id: dm-devel.ids

Ritesh Raj Sarraf wrote:
> I'm using dm-crypt on an external USB enclosure ide hdd. I copied 20Gb of 
> data on to the encrypted device and am suffering severe performance penalty.
> After a couple of seconds, all processes involved in the I/O keep stalling. 
> They periodically resume, just for a couple of seconds and then again stall.
> 
> Running linux 2.6.26.

Please can you try it without dm-crypt involved?
Just copy 20Gb to your unencrypted disk attached through USB.

I saw this problem with plain USB attached storage some time ago too.

There is only one thread in dm-crypt and it is waiting for io_schedule,
so I think it is not dm-crypt who is blocking it, but the layer
below the dm-crypt.

Milan

> [15869.848387] kcryptd       D f7044a0c     0 13656      2                                                            
> [15869.848387]        f29d79c0 00000046 01c58000 f7044a0c c03c1430 c03c4740 
> c03c4740 f29d79c0                         
> [15869.848387]        f29d7b4c c201c740 00000001 00010001 00000001 f79b48d0 
> f29d7b4c 00eb4b70                         
> [15869.848387]        c01df9a6 c0135b72 00000000 00000000 00000000 000000ff 
> c201c740 c201cb44                         
> [15869.848387] Call Trace:                                                                                            
> [15869.848387]  [<c01df9a6>] cfq_may_queue+0x48/0xab                                                                  
> [15869.848387]  [<c0135b72>] getnstimeofday+0x32/0xaf                                                                 
> [15869.848387]  [<c02c1091>] io_schedule+0x4f/0x86                                                                    
> [15869.848387]  [<c01d734f>] get_request_wait+0xf2/0x16d                                                              
> [15869.848387]  [<c013140a>] autoremove_wake_function+0x0/0x2d                                                        
> [15869.848387]  [<c01d7789>] __make_request+0x2b7/0x33a                                                               
> [15869.848387]  [<c01d6465>] generic_make_request+0x419/0x44a                                                         
> [15869.848387]  [<f8c30563>] async_encrypt+0x2f/0x35 [crypto_blkcipher]                                               
> [15869.848387]  [<f8c659ce>] crypt_convert+0x20e/0x240 [dm_crypt]                                                     
> [15869.848387]  [<f8c65c5d>] kcryptd_crypt+0x25d/0x339 [dm_crypt]                                                     
> [15869.848387]  [<f8c65a00>] kcryptd_crypt+0x0/0x339 [dm_crypt]                                                       
> [15869.848387]  [<f8c65a00>] kcryptd_crypt+0x0/0x339 [dm_crypt]                                                       
> [15869.848387]  [<c012e818>] run_workqueue+0x73/0xed                                                                  
> [15869.848387]  [<c012e949>] worker_thread+0xb7/0xc3                                                                  
> [15869.848387]  [<c013140a>] autoremove_wake_function+0x0/0x2d                                                        
> [15869.848387]  [<c012e892>] worker_thread+0x0/0xc3                                                                   
> [15869.848387]  [<c01311a6>] kthread+0x38/0x5d                                                                        
> [15869.848387]  [<c013116e>] kthread+0x0/0x5d                                                                         
> [15869.848387]  [<c01045af>] kernel_thread_helper+0x7/0x10                                                            

Milan
--
mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
