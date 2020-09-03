From: Coly Li <colyli@suse.de>
Subject: Re: flood of "dm-X: error: dax access failed" due to 5.9
 commit 231609785cbfb
Date: Thu, 3 Sep 2020 13:05:13 +0800
Message-ID: <d175dda1-d196-8283-d099-9e4db70f96aa@suse.de>
References: <20200902160432.GA5513@redhat.com>
	<df0203fa-7f75-53ac-8bf1-79a1c861918e@suse.de>
	<20200902164456.GA5928@redhat.com>
	<4968af50-663d-74cf-1be2-aaed48a380d5@suse.de>
	<20200902165101.GB5928@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------0F92E39F92669280CF59FFE0"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200902165101.GB5928@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-US
To: Mike Snitzer <snitzer@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, dm-devel@redhat.com, Jan Kara <jack@suse.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------0F92E39F92669280CF59FFE0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2020/9/3 00:51, Mike Snitzer wrote:
> On Wed, Sep 02 2020 at 12:46pm -0400,
> Coly Li <colyli@suse.de> wrote:
> 
>> On 2020/9/3 00:44, Mike Snitzer wrote:
>>> On Wed, Sep 02 2020 at 12:40pm -0400,
>>> Coly Li <colyli@suse.de> wrote:
>>>
>>>> On 2020/9/3 00:04, Mike Snitzer wrote:
>>>>> 5.9 commit 231609785cbfb ("dax: print error message by pr_info() in
>>>>> __generic_fsdax_supported()") switched from pr_debug() to pr_info().
>>>>>
>>>>> The justification in the commit header is really inadequate.  If there
>>>>> is a problem that you need to drill in on, repeat the testing after
>>>>> enabling the dynamic debugging.
>>>>>
>>>>> Otherwise, now all DM devices that aren't layered on DAX capable devices
>>>>> spew really confusing noise to users when they simply activate their
>>>>> non-DAX DM devices:
>>>>>
>>>>> [66567.129798] dm-6: error: dax access failed (-5)
>>>>> [66567.134400] dm-6: error: dax access failed (-5)
>>>>> [66567.139152] dm-6: error: dax access failed (-5)
>>>>> [66567.314546] dm-2: error: dax access failed (-95)
>>>>> [66567.319380] dm-2: error: dax access failed (-95)
>>>>> [66567.324254] dm-2: error: dax access failed (-95)
>>>>> [66567.479025] dm-2: error: dax access failed (-95)
>>>>> [66567.483713] dm-2: error: dax access failed (-95)
>>>>> [66567.488722] dm-2: error: dax access failed (-95)
>>>>> [66567.494061] dm-2: error: dax access failed (-95)
>>>>> [66567.498823] dm-2: error: dax access failed (-95)
>>>>> [66567.503693] dm-2: error: dax access failed (-95)
>>>>>
>>>>> commit 231609785cbfb must be reverted.
>>>>>
>>>>> Please advise, thanks.
>>>>
>>>> Adrian Huang from Lenovo posted a patch, which titled: dax: do not print
>>>> error message for non-persistent memory block device
>>>>
>>>> It fixes the issue, but no response for now. Maybe we should take this fix.
>>>
>>> OK, yes sounds like it.  It was merged and is commit c2affe920b0e066
>>> ("dax: do not print error message for non-persistent memory block
>>> device")
>>
>> Thanks for informing me this patch is merged, I am going to update my
>> local one :-)
> 
> So the thing is I'm running v5.9-rc3 (which includes this commit) but
> I'm still seeing all these warnings when I run the lvm2 testsuite.  The
> reason _seems_ to be because the lvm2 testsuite uses brd devices for
> test devices.  So there is something about the brd device that shows
> commit c2affe920b0e066 isn't enough :(

Could you please apply and test this attached patch based on v5.9-rc3 ?

It seems the pointer dax_dev of __generic_fsdax_supported() parameter is
not initialized (IMHO this is not a dm bug), therefore the && should be
|| to check the dax support state.

Also I add two pr_info() to print the variables value, let's see whether
my guess makes sense.

Thanks.

Coly Li


--------------0F92E39F92669280CF59FFE0
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
	name="0001-dax-fix-for-do-not-print-error-message-for-non-persi.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename*0="0001-dax-fix-for-do-not-print-error-message-for-non-persi.pa";
	filename*1="tch"

RnJvbSAzNzE0YjkxMzYyNjY5YzRkM2UyODFhY2ZlMTk3ZTkyMmExZGQxYjRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KRGF0ZTogVGh1LCAz
IFNlcCAyMDIwIDEyOjI1OjEzICswODAwClN1YmplY3Q6IFtQQVRDSF0gZGF4OiBmaXggZm9yIGRv
IG5vdCBwcmludCBlcnJvciBtZXNzYWdlIGZvciBub24tcGVyc2lzdGVudAogbWVtb3J5IGJsb2Nr
IGRldmljZQoKV2hlbiBjYWxsaW5nIF9fZ2VuZXJpY19mc2RheF9zdXBwb3J0ZWQoKSwgYSBkYXgt
dW5zdXBwb3J0ZWQgZGV2aWNlIG1heQpub3QgaGF2ZSBkYXhfZGV2IGFzIE5VTEwuIFRoZXJlZm9y
ZSBldmVuIGRheF9kZXYgaXMgbm90IE5VTEwsIGl0IGlzCnN0aWxsIG5lY2Vzc2FyeSB0byBjYWxs
IGJkZXZfZGF4X3N1cHBvcnRlZCgpIHRvIGNoZWNrIHdoZXRoZXIgdGhlIGRldmljZQpzdXBwb3J0
cyBkYXguCgpTaWduZWQtb2ZmLWJ5OiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KLS0tCiBkcml2
ZXJzL2RheC9zdXBlci5jIHwgNCArKystCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9kYXgvc3VwZXIuYyBiL2RyaXZl
cnMvZGF4L3N1cGVyLmMKaW5kZXggMzI2NDI2MzRjMWJiLi5hNWJkZmNhMDUyOWEgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvZGF4L3N1cGVyLmMKKysrIGIvZHJpdmVycy9kYXgvc3VwZXIuYwpAQCAtMTAw
LDcgKzEwMCw5IEBAIGJvb2wgX19nZW5lcmljX2ZzZGF4X3N1cHBvcnRlZChzdHJ1Y3QgZGF4X2Rl
dmljZSAqZGF4X2RldiwKIAkJcmV0dXJuIGZhbHNlOwogCX0KIAotCWlmICghZGF4X2RldiAmJiAh
YmRldl9kYXhfc3VwcG9ydGVkKGJkZXYsIGJsb2Nrc2l6ZSkpIHsKKwlwcl9pbmZvKCJkYXhfZGV2
OiAlcFxuIiwgZGF4X2Rldik7CisJcHJfaW5mbygiYmRldl9kYXhfc3VwcG9ydGVkKCk6ICVkXG4i
LCBiZGV2X2RheF9zdXBwb3J0ZWQoYmRldiwgYmxvY2tzaXplKSk7CisJaWYgKCFkYXhfZGV2IHx8
ICFiZGV2X2RheF9zdXBwb3J0ZWQoYmRldiwgYmxvY2tzaXplKSkgewogCQlwcl9kZWJ1ZygiJXM6
IGVycm9yOiBkYXggdW5zdXBwb3J0ZWQgYnkgYmxvY2sgZGV2aWNlXG4iLAogCQkJCWJkZXZuYW1l
KGJkZXYsIGJ1ZikpOwogCQlyZXR1cm4gZmFsc2U7Ci0tIAoyLjI2LjIKCg==
--------------0F92E39F92669280CF59FFE0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------0F92E39F92669280CF59FFE0--
