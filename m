From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt: support using encrypted keys
Date: Wed, 22 Apr 2020 18:47:51 +0200
Message-ID: <e3b78a32-4307-c60c-f9c3-dd6d71b6633c@gmail.com>
References: <20200420134659.1640089-1-dbaryshkov@gmail.com>
	<20200421182754.GA49104@lobo>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200421182754.GA49104@lobo>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>, David Howells <dhowells@redhat.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 21/04/2020 20:27, Mike Snitzer wrote:
> On Mon, Apr 20 2020 at  9:46P -0400,
> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> 
>> From: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>
>>
>> Allow one to use encrypted in addition to user and login key types for
>> device encryption.
>>
>> Signed-off-by: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>
> 
> I fixed up some issues, please see the following incremental patch,
> I'll get this folded in and staged for 5.8.

And you just created hard dependence on encrypted key type...

If you disable this type (CONFIG_ENCRYPTED_KEYS option), it cannot load the module anymore:
ERROR: modpost: "key_type_encrypted" [drivers/md/dm-crypt.ko] undefined!

We had this idea before, and this implementation in dm-crypt just requires dynamic
key type loading implemented first.

David Howells (cc) promised that moths ago, but apparently nothing was yet submitted
(and the proof-of-concept patch no longer works).

Mike, I think you should revert this patch from the tree until it is solved.

Once fixed, we should also support "trusted" key type.

Also please -  do no forget to increase dm-crypt minor version here...

Thanks,
Milan
