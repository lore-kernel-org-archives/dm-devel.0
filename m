From: Germano Percossi <germano.percossi@citrix.com>
Subject: Re: [PATCH 06/15] libmultipath: Remove an unused function
Date: Mon, 24 Oct 2016 15:55:22 +0100
Message-ID: <d5cc4da4-3c6a-7bef-aff9-18e40922f07d@citrix.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
	<1fcae43b-f64e-7001-ef0d-68ec0585c81d@sandisk.com>
	<2b174b78-f42b-2c7f-90da-00b05cba1f6d@citrix.com>
	<c29b1e88-4dac-9bb7-e701-527cae23dbe6@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c29b1e88-4dac-9bb7-e701-527cae23dbe6@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Sorry, my reply was meant for mpath_prin_pthread_fn patch but,
I guess, given the lack of a declaration in a header file,
your answer will be the same.

Germano

On 10/24/2016 03:26 PM, Bart Van Assche wrote:
> On 10/24/16 03:50, Germano Percossi wrote:
>> On 10/21/2016 07:43 PM, Bart Van Assche wrote:
>>> The function snprint_config() is not used. Hence remove it.
>>>
>>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>>> ---
>>>  libmultipath/print.c | 6 ------
>>>  1 file changed, 6 deletions(-)
>>>
>>> diff --git a/libmultipath/print.c b/libmultipath/print.c
>>> index 9aa41ad..09e4a2e 100644
>>> --- a/libmultipath/print.c
>>> +++ b/libmultipath/print.c
>>> @@ -1745,12 +1745,6 @@ snprint_devices (struct config *conf, char *
>>> buff, int len, struct vectors *vecs
>>>      return fwd;
>>>  }
>>>
>>> -extern int
>>> -snprint_config (char * buff, int len)
>>> -{
>>> -    return 0;
>>> -}
>>> -
>>>  /*
>>>   * stdout printing helpers
>>>   */
>>
>> Removing functions packaged in a library just because they are
>> not used in multipath does not seem fine, in general.
>> They could still be used by third party.
> 
> Hello Germano,
> 
> The snprint_config() function has never been declared in any
> multipath-tools header file so if someone would want to use this
> function without triggering a compiler warning they would have to add
> something like "extern int snprint_config (char * buff, int len)" to
> their source code. Because of this reason and also because of the empty
> implementation I think that is unlikely that any project is using this
> function.
> 
> Bart.
> 
