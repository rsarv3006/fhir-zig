    /// Other claims which are related to this claim such as prior submissions or claims for related services or for the same event.
pub const Claim_Related = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// Reference to a related claim.
    claim: ?Reference = null,
        /// A code to convey how the claims are related.
    relationship: ?CodeableConcept = null,
        /// An alternate organizational reference to the case or file to which this particular claim pertains.
    reference: ?Identifier = null,

};

    /// The party to be reimbursed for cost of the products and services according to the terms of the policy.
pub const Claim_Payee = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// Type of Party to be reimbursed: subscriber, provider, other.
    @"type": CodeableConcept,
        /// Reference to the individual or organization to whom any payment will be made.
    party: ?Reference = null,

};

    /// The members of the team who provided the products and services.
pub const Claim_CareTeam = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely identify care team entries.
    sequence: positiveInt,
        /// Member of the team who provided the product or service.
    provider: Reference,
        /// The party who is billing and/or responsible for the claimed products or services.
    responsible: ?boolean = null,
        /// The lead, assisting or supervising practitioner and their discipline if a multidisciplinary team.
    role: ?CodeableConcept = null,
        /// The qualification of the practitioner which is applicable for this service.
    qualification: ?CodeableConcept = null,

};

    /// Additional information codes regarding exceptions, special considerations, the condition, situation, prior or concurrent issues.
pub const Claim_SupportingInfo = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely identify supporting information entries.
    sequence: positiveInt,
        /// The general class of the information supplied: information; exception; accident, employment; onset, etc.
    category: CodeableConcept,
        /// System and code pertaining to the specific information regarding special conditions relating to the setting, treatment or patient  for which care is sought.
    code: ?CodeableConcept = null,
        /// The date when or period to which this information refers.
    timing[x]: ?unknown = null,
        /// Additional data or information such as resources, documents, images etc. including references to the data or the actual inclusion of the data.
    value[x]: ?unknown = null,
        /// Provides the reason in the situation where a reason code is required in addition to the content.
    reason: ?CodeableConcept = null,

};

    /// Information about diagnoses relevant to the claim items.
pub const Claim_Diagnosis = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely identify diagnosis entries.
    sequence: positiveInt,
        /// The nature of illness or problem in a coded form or as a reference to an external defined Condition.
    diagnosis[x]: unknown,
        /// When the condition was observed or the relative ranking.
    @"type": ?[] const CodeableConcept = null,
        /// Indication of whether the diagnosis was present on admission to a facility.
    onAdmission: ?CodeableConcept = null,
        /// A package billing code or bundle code used to group products and services to a particular health condition (such as heart attack) which is based on a predetermined grouping code system.
    packageCode: ?CodeableConcept = null,

};

    /// Procedures performed on the patient relevant to the billing items with the claim.
pub const Claim_Procedure = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely identify procedure entries.
    sequence: positiveInt,
        /// When the condition was observed or the relative ranking.
    @"type": ?[] const CodeableConcept = null,
        /// Date and optionally time the procedure was performed.
    date: ?dateTime = null,
        /// The code or reference to a Procedure resource which identifies the clinical intervention performed.
    procedure[x]: unknown,
        /// Unique Device Identifiers associated with this line item.
    udi: ?[] const Reference = null,

};

    /// Financial instruments for reimbursement for the health care products and services specified on the claim.
pub const Claim_Insurance = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely identify insurance entries and provide a sequence of coverages to convey coordination of benefit order.
    sequence: positiveInt,
        /// A flag to indicate that this Coverage is to be used for adjudication of this claim when set to true.
    focal: boolean,
        /// The business identifier to be used when the claim is sent for adjudication against this insurance policy.
    identifier: ?Identifier = null,
        /// Reference to the insurance card level information contained in the Coverage resource. The coverage issuing insurer will use these details to locate the patient's actual coverage within the insurer's information system.
    coverage: Reference,
        /// A business agreement number established between the provider and the insurer for special business processing purposes.
    businessArrangement: ?string = null,
        /// Reference numbers previously provided by the insurer to the provider to be quoted on subsequent claims containing services or products related to the prior authorization.
    preAuthRef: ?[] const string = null,
        /// The result of the adjudication of the line items for the Coverage specified in this insurance.
    claimResponse: ?Reference = null,

};

    /// Details of an accident which resulted in injuries which required the products and services listed in the claim.
pub const Claim_Accident = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// Date of an accident event  related to the products and services contained in the claim.
    date: date,
        /// The type or context of the accident event for the purposes of selection of potential insurance coverages and determination of coordination between insurers.
    @"type": ?CodeableConcept = null,
        /// The physical location of the accident event.
    location[x]: ?unknown = null,

};

    /// A claim detail line. Either a simple (a product or service) or a 'group' of sub-details which are simple items.
pub const Claim_Item_Detail_SubDetail = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely identify item entries.
    sequence: positiveInt,
        /// The type of revenue or cost center providing the product and/or service.
    revenue: ?CodeableConcept = null,
        /// Code to identify the general type of benefits under which products and services are provided.
    category: ?CodeableConcept = null,
        /// When the value is a group code then this item collects a set of related claim details, otherwise this contains the product, service, drug or other billing code for the item.
    productOrService: CodeableConcept,
        /// Item typification or modifiers codes to convey additional context for the product or service.
    modifier: ?[] const CodeableConcept = null,
        /// Identifies the program under which this may be recovered.
    programCode: ?[] const CodeableConcept = null,
        /// The number of repetitions of a service or product.
    quantity: ?Quantity = null,
        /// If the item is not a group then this is the fee for the product or service, otherwise this is the total of the fees for the details of the group.
    unitPrice: ?Money = null,
        /// A real number that represents a multiplier used in determining the overall value of services delivered and/or goods received. The concept of a Factor allows for a discount or surcharge multiplier to be applied to a monetary amount.
    factor: ?decimal = null,
        /// The quantity times the unit price for an additional service or product or charge.
    net: ?Money = null,
        /// Unique Device Identifiers associated with this line item.
    udi: ?[] const Reference = null,

};

    /// A claim detail line. Either a simple (a product or service) or a 'group' of sub-details which are simple items.
pub const Claim_Item_Detail = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely identify item entries.
    sequence: positiveInt,
        /// The type of revenue or cost center providing the product and/or service.
    revenue: ?CodeableConcept = null,
        /// Code to identify the general type of benefits under which products and services are provided.
    category: ?CodeableConcept = null,
        /// When the value is a group code then this item collects a set of related claim details, otherwise this contains the product, service, drug or other billing code for the item.
    productOrService: CodeableConcept,
        /// Item typification or modifiers codes to convey additional context for the product or service.
    modifier: ?[] const CodeableConcept = null,
        /// Identifies the program under which this may be recovered.
    programCode: ?[] const CodeableConcept = null,
        /// The number of repetitions of a service or product.
    quantity: ?Quantity = null,
        /// If the item is not a group then this is the fee for the product or service, otherwise this is the total of the fees for the details of the group.
    unitPrice: ?Money = null,
        /// A real number that represents a multiplier used in determining the overall value of services delivered and/or goods received. The concept of a Factor allows for a discount or surcharge multiplier to be applied to a monetary amount.
    factor: ?decimal = null,
        /// The quantity times the unit price for an additional service or product or charge.
    net: ?Money = null,
        /// Unique Device Identifiers associated with this line item.
    udi: ?[] const Reference = null,
        /// A claim detail line. Either a simple (a product or service) or a 'group' of sub-details which are simple items.
    subDetail: ?[] const Claim_Item_Detail_SubDetail = null,

};

    /// A claim line. Either a simple  product or service or a 'group' of details which can each be a simple items or groups of sub-details.
pub const Claim_Item = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely identify item entries.
    sequence: positiveInt,
        /// CareTeam members related to this service or product.
    careTeamSequence: ?[] const positiveInt = null,
        /// Diagnosis applicable for this service or product.
    diagnosisSequence: ?[] const positiveInt = null,
        /// Procedures applicable for this service or product.
    procedureSequence: ?[] const positiveInt = null,
        /// Exceptions, special conditions and supporting information applicable for this service or product.
    informationSequence: ?[] const positiveInt = null,
        /// The type of revenue or cost center providing the product and/or service.
    revenue: ?CodeableConcept = null,
        /// Code to identify the general type of benefits under which products and services are provided.
    category: ?CodeableConcept = null,
        /// When the value is a group code then this item collects a set of related claim details, otherwise this contains the product, service, drug or other billing code for the item.
    productOrService: CodeableConcept,
        /// Item typification or modifiers codes to convey additional context for the product or service.
    modifier: ?[] const CodeableConcept = null,
        /// Identifies the program under which this may be recovered.
    programCode: ?[] const CodeableConcept = null,
        /// The date or dates when the service or product was supplied, performed or completed.
    serviced[x]: ?unknown = null,
        /// Where the product or service was provided.
    location[x]: ?unknown = null,
        /// The number of repetitions of a service or product.
    quantity: ?Quantity = null,
        /// If the item is not a group then this is the fee for the product or service, otherwise this is the total of the fees for the details of the group.
    unitPrice: ?Money = null,
        /// A real number that represents a multiplier used in determining the overall value of services delivered and/or goods received. The concept of a Factor allows for a discount or surcharge multiplier to be applied to a monetary amount.
    factor: ?decimal = null,
        /// The quantity times the unit price for an additional service or product or charge.
    net: ?Money = null,
        /// Unique Device Identifiers associated with this line item.
    udi: ?[] const Reference = null,
        /// Physical service site on the patient (limb, tooth, etc.).
    bodySite: ?CodeableConcept = null,
        /// A region or surface of the bodySite, e.g. limb region or tooth surface(s).
    subSite: ?[] const CodeableConcept = null,
        /// The Encounters during which this Claim was created or to which the creation of this record is tightly associated.
    encounter: ?[] const Reference = null,
        /// A claim detail line. Either a simple (a product or service) or a 'group' of sub-details which are simple items.
    detail: ?[] const Claim_Item_Detail = null,

};

    /// A provider issued list of professional services and products which have been provided, or are to be provided, to a patient which is sent to an insurer for reimbursement.
pub const Claim = struct {
    resourceType: []const u8 = "Claim",
        /// The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
    id: ?string = null,
        /// The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
    meta: ?Meta = null,
        /// A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
    implicitRules: ?uri = null,
        /// The base language in which the resource is written.
    language: ?code = null,
        /// A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it "clinically safe" for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
    text: ?Narrative = null,
        /// These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
    contained: ?[] const Resource = null,
        /// May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A unique identifier assigned to this claim.
    identifier: ?[] const Identifier = null,
        /// The status of the resource instance.
    status: code,
        /// The category of claim, e.g. oral, pharmacy, vision, institutional, professional.
    @"type": CodeableConcept,
        /// A finer grained suite of claim type codes which may convey additional information such as Inpatient vs Outpatient and/or a specialty service.
    subType: ?CodeableConcept = null,
        /// A code to indicate whether the nature of the request is: to request adjudication of products and services previously rendered; or requesting authorization and adjudication for provision in the future; or requesting the non-binding adjudication of the listed products and services which could be provided in the future.
    use: code,
        /// The party to whom the professional services and/or products have been supplied or are being considered and for whom actual or forecast reimbursement is sought.
    patient: Reference,
        /// The period for which charges are being submitted.
    billablePeriod: ?Period = null,
        /// The date this resource was created.
    created: dateTime,
        /// Individual who created the claim, predetermination or preauthorization.
    enterer: ?Reference = null,
        /// The Insurer who is target of the request.
    insurer: ?Reference = null,
        /// The provider which is responsible for the claim, predetermination or preauthorization.
    provider: Reference,
        /// The provider-required urgency of processing the request. Typical values include: stat, routine deferred.
    priority: CodeableConcept,
        /// A code to indicate whether and for whom funds are to be reserved for future claims.
    fundsReserve: ?CodeableConcept = null,
        /// Other claims which are related to this claim such as prior submissions or claims for related services or for the same event.
    related: ?[] const Claim_Related = null,
        /// Prescription to support the dispensing of pharmacy, device or vision products.
    prescription: ?Reference = null,
        /// Original prescription which has been superseded by this prescription to support the dispensing of pharmacy services, medications or products.
    originalPrescription: ?Reference = null,
        /// The party to be reimbursed for cost of the products and services according to the terms of the policy.
    payee: ?Claim_Payee = null,
        /// A reference to a referral resource.
    referral: ?Reference = null,
        /// Facility where the services were provided.
    facility: ?Reference = null,
        /// The members of the team who provided the products and services.
    careTeam: ?[] const Claim_CareTeam = null,
        /// Additional information codes regarding exceptions, special considerations, the condition, situation, prior or concurrent issues.
    supportingInfo: ?[] const Claim_SupportingInfo = null,
        /// Information about diagnoses relevant to the claim items.
    diagnosis: ?[] const Claim_Diagnosis = null,
        /// Procedures performed on the patient relevant to the billing items with the claim.
    procedure: ?[] const Claim_Procedure = null,
        /// Financial instruments for reimbursement for the health care products and services specified on the claim.
    insurance: [] const Claim_Insurance,
        /// Details of an accident which resulted in injuries which required the products and services listed in the claim.
    accident: ?Claim_Accident = null,
        /// A claim line. Either a simple  product or service or a 'group' of details which can each be a simple items or groups of sub-details.
    item: ?[] const Claim_Item = null,
        /// The total value of the all the items in the claim.
    total: ?Money = null,

};

    /// If this item is a group then the values here are a summary of the adjudication of the detail items. If this item is a simple product or service then this is the result of the adjudication of this item.
pub const ClaimResponse_Item_Adjudication = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A code to indicate the information type of this adjudication record. Information types may include the value submitted, maximum values or percentages allowed or payable under the plan, amounts that: the patient is responsible for in aggregate or pertaining to this item; amounts paid by other coverages; and, the benefit payable for this item.
    category: CodeableConcept,
        /// A code supporting the understanding of the adjudication result and explaining variance from expected amount.
    reason: ?CodeableConcept = null,
        /// Monetary amount associated with the category.
    amount: ?Money = null,
        /// A non-monetary value associated with the category. Mutually exclusive to the amount element above.
    value: ?decimal = null,

};

    /// A sub-detail adjudication of a simple product or service.
pub const ClaimResponse_Item_Detail_SubDetail = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely reference the claim sub-detail entry.
    subDetailSequence: positiveInt,
        /// The numbers associated with notes below which apply to the adjudication of this item.
    noteNumber: ?[] const positiveInt = null,
        /// The adjudication results.
    adjudication: ?[] const unknown = null,

};

    /// A claim detail. Either a simple (a product or service) or a 'group' of sub-details which are simple items.
pub const ClaimResponse_Item_Detail = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely reference the claim detail entry.
    detailSequence: positiveInt,
        /// The numbers associated with notes below which apply to the adjudication of this item.
    noteNumber: ?[] const positiveInt = null,
        /// The adjudication results.
    adjudication: [] const unknown,
        /// A sub-detail adjudication of a simple product or service.
    subDetail: ?[] const ClaimResponse_Item_Detail_SubDetail = null,

};

    /// A claim line. Either a simple (a product or service) or a 'group' of details which can also be a simple items or groups of sub-details.
pub const ClaimResponse_Item = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely reference the claim item entries.
    itemSequence: positiveInt,
        /// The numbers associated with notes below which apply to the adjudication of this item.
    noteNumber: ?[] const positiveInt = null,
        /// If this item is a group then the values here are a summary of the adjudication of the detail items. If this item is a simple product or service then this is the result of the adjudication of this item.
    adjudication: [] const ClaimResponse_Item_Adjudication,
        /// A claim detail. Either a simple (a product or service) or a 'group' of sub-details which are simple items.
    detail: ?[] const ClaimResponse_Item_Detail = null,

};

    /// The third-tier service adjudications for payor added services.
pub const ClaimResponse_AddItem_Detail_SubDetail = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// When the value is a group code then this item collects a set of related claim details, otherwise this contains the product, service, drug or other billing code for the item.
    productOrService: CodeableConcept,
        /// Item typification or modifiers codes to convey additional context for the product or service.
    modifier: ?[] const CodeableConcept = null,
        /// The number of repetitions of a service or product.
    quantity: ?Quantity = null,
        /// If the item is not a group then this is the fee for the product or service, otherwise this is the total of the fees for the details of the group.
    unitPrice: ?Money = null,
        /// A real number that represents a multiplier used in determining the overall value of services delivered and/or goods received. The concept of a Factor allows for a discount or surcharge multiplier to be applied to a monetary amount.
    factor: ?decimal = null,
        /// The quantity times the unit price for an additional service or product or charge.
    net: ?Money = null,
        /// The numbers associated with notes below which apply to the adjudication of this item.
    noteNumber: ?[] const positiveInt = null,
        /// The adjudication results.
    adjudication: [] const unknown,

};

    /// The second-tier service adjudications for payor added services.
pub const ClaimResponse_AddItem_Detail = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// When the value is a group code then this item collects a set of related claim details, otherwise this contains the product, service, drug or other billing code for the item.
    productOrService: CodeableConcept,
        /// Item typification or modifiers codes to convey additional context for the product or service.
    modifier: ?[] const CodeableConcept = null,
        /// The number of repetitions of a service or product.
    quantity: ?Quantity = null,
        /// If the item is not a group then this is the fee for the product or service, otherwise this is the total of the fees for the details of the group.
    unitPrice: ?Money = null,
        /// A real number that represents a multiplier used in determining the overall value of services delivered and/or goods received. The concept of a Factor allows for a discount or surcharge multiplier to be applied to a monetary amount.
    factor: ?decimal = null,
        /// The quantity times the unit price for an additional service or product or charge.
    net: ?Money = null,
        /// The numbers associated with notes below which apply to the adjudication of this item.
    noteNumber: ?[] const positiveInt = null,
        /// The adjudication results.
    adjudication: [] const unknown,
        /// The third-tier service adjudications for payor added services.
    subDetail: ?[] const ClaimResponse_AddItem_Detail_SubDetail = null,

};

    /// The first-tier service adjudications for payor added product or service lines.
pub const ClaimResponse_AddItem = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// Claim items which this service line is intended to replace.
    itemSequence: ?[] const positiveInt = null,
        /// The sequence number of the details within the claim item which this line is intended to replace.
    detailSequence: ?[] const positiveInt = null,
        /// The sequence number of the sub-details within the details within the claim item which this line is intended to replace.
    subdetailSequence: ?[] const positiveInt = null,
        /// The providers who are authorized for the services rendered to the patient.
    provider: ?[] const Reference = null,
        /// When the value is a group code then this item collects a set of related claim details, otherwise this contains the product, service, drug or other billing code for the item.
    productOrService: CodeableConcept,
        /// Item typification or modifiers codes to convey additional context for the product or service.
    modifier: ?[] const CodeableConcept = null,
        /// Identifies the program under which this may be recovered.
    programCode: ?[] const CodeableConcept = null,
        /// The date or dates when the service or product was supplied, performed or completed.
    serviced[x]: ?unknown = null,
        /// Where the product or service was provided.
    location[x]: ?unknown = null,
        /// The number of repetitions of a service or product.
    quantity: ?Quantity = null,
        /// If the item is not a group then this is the fee for the product or service, otherwise this is the total of the fees for the details of the group.
    unitPrice: ?Money = null,
        /// A real number that represents a multiplier used in determining the overall value of services delivered and/or goods received. The concept of a Factor allows for a discount or surcharge multiplier to be applied to a monetary amount.
    factor: ?decimal = null,
        /// The quantity times the unit price for an additional service or product or charge.
    net: ?Money = null,
        /// Physical service site on the patient (limb, tooth, etc.).
    bodySite: ?CodeableConcept = null,
        /// A region or surface of the bodySite, e.g. limb region or tooth surface(s).
    subSite: ?[] const CodeableConcept = null,
        /// The numbers associated with notes below which apply to the adjudication of this item.
    noteNumber: ?[] const positiveInt = null,
        /// The adjudication results.
    adjudication: [] const unknown,
        /// The second-tier service adjudications for payor added services.
    detail: ?[] const ClaimResponse_AddItem_Detail = null,

};

    /// Categorized monetary totals for the adjudication.
pub const ClaimResponse_Total = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A code to indicate the information type of this adjudication record. Information types may include: the value submitted, maximum values or percentages allowed or payable under the plan, amounts that the patient is responsible for in aggregate or pertaining to this item, amounts paid by other coverages, and the benefit payable for this item.
    category: CodeableConcept,
        /// Monetary total amount associated with the category.
    amount: Money,

};

    /// Payment details for the adjudication of the claim.
pub const ClaimResponse_Payment = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// Whether this represents partial or complete payment of the benefits payable.
    @"type": CodeableConcept,
        /// Total amount of all adjustments to this payment included in this transaction which are not related to this claim's adjudication.
    adjustment: ?Money = null,
        /// Reason for the payment adjustment.
    adjustmentReason: ?CodeableConcept = null,
        /// Estimated date the payment will be issued or the actual issue date of payment.
    date: ?date = null,
        /// Benefits payable less any payment adjustment.
    amount: Money,
        /// Issuer's unique identifier for the payment instrument.
    identifier: ?Identifier = null,

};

    /// A note that describes or explains adjudication results in a human readable form.
pub const ClaimResponse_ProcessNote = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely identify a note entry.
    number: ?positiveInt = null,
        /// The business purpose of the note text.
    @"type": ?code = null,
        /// The explanation or description associated with the processing.
    text: string,
        /// A code to define the language used in the text of the note.
    language: ?CodeableConcept = null,

};

    /// Financial instruments for reimbursement for the health care products and services specified on the claim.
pub const ClaimResponse_Insurance = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A number to uniquely identify insurance entries and provide a sequence of coverages to convey coordination of benefit order.
    sequence: positiveInt,
        /// A flag to indicate that this Coverage is to be used for adjudication of this claim when set to true.
    focal: boolean,
        /// Reference to the insurance card level information contained in the Coverage resource. The coverage issuing insurer will use these details to locate the patient's actual coverage within the insurer's information system.
    coverage: Reference,
        /// A business agreement number established between the provider and the insurer for special business processing purposes.
    businessArrangement: ?string = null,
        /// The result of the adjudication of the line items for the Coverage specified in this insurance.
    claimResponse: ?Reference = null,

};

    /// Errors encountered during the processing of the adjudication.
pub const ClaimResponse_Error = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// The sequence number of the line item submitted which contains the error. This value is omitted when the error occurs outside of the item structure.
    itemSequence: ?positiveInt = null,
        /// The sequence number of the detail within the line item submitted which contains the error. This value is omitted when the error occurs outside of the item structure.
    detailSequence: ?positiveInt = null,
        /// The sequence number of the sub-detail within the detail within the line item submitted which contains the error. This value is omitted when the error occurs outside of the item structure.
    subDetailSequence: ?positiveInt = null,
        /// An error code, from a specified code system, which details why the claim could not be adjudicated.
    code: CodeableConcept,

};

    /// This resource provides the adjudication details from the processing of a Claim resource.
pub const ClaimResponse = struct {
    resourceType: []const u8 = "ClaimResponse",
        /// The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
    id: ?string = null,
        /// The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
    meta: ?Meta = null,
        /// A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
    implicitRules: ?uri = null,
        /// The base language in which the resource is written.
    language: ?code = null,
        /// A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it "clinically safe" for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
    text: ?Narrative = null,
        /// These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
    contained: ?[] const Resource = null,
        /// May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// A unique identifier assigned to this claim response.
    identifier: ?[] const Identifier = null,
        /// The status of the resource instance.
    status: code,
        /// A finer grained suite of claim type codes which may convey additional information such as Inpatient vs Outpatient and/or a specialty service.
    @"type": CodeableConcept,
        /// A finer grained suite of claim type codes which may convey additional information such as Inpatient vs Outpatient and/or a specialty service.
    subType: ?CodeableConcept = null,
        /// A code to indicate whether the nature of the request is: to request adjudication of products and services previously rendered; or requesting authorization and adjudication for provision in the future; or requesting the non-binding adjudication of the listed products and services which could be provided in the future.
    use: code,
        /// The party to whom the professional services and/or products have been supplied or are being considered and for whom actual for facast reimbursement is sought.
    patient: Reference,
        /// The date this resource was created.
    created: dateTime,
        /// The party responsible for authorization, adjudication and reimbursement.
    insurer: Reference,
        /// The provider which is responsible for the claim, predetermination or preauthorization.
    requestor: ?Reference = null,
        /// Original request resource reference.
    request: ?Reference = null,
        /// The outcome of the claim, predetermination, or preauthorization processing.
    outcome: code,
        /// A human readable description of the status of the adjudication.
    disposition: ?string = null,
        /// Reference from the Insurer which is used in later communications which refers to this adjudication.
    preAuthRef: ?string = null,
        /// The time frame during which this authorization is effective.
    preAuthPeriod: ?Period = null,
        /// Type of Party to be reimbursed: subscriber, provider, other.
    payeeType: ?CodeableConcept = null,
        /// A claim line. Either a simple (a product or service) or a 'group' of details which can also be a simple items or groups of sub-details.
    item: ?[] const ClaimResponse_Item = null,
        /// The first-tier service adjudications for payor added product or service lines.
    addItem: ?[] const ClaimResponse_AddItem = null,
        /// The adjudication results which are presented at the header level rather than at the line-item or add-item levels.
    adjudication: ?[] const unknown = null,
        /// Categorized monetary totals for the adjudication.
    total: ?[] const ClaimResponse_Total = null,
        /// Payment details for the adjudication of the claim.
    payment: ?ClaimResponse_Payment = null,
        /// A code, used only on a response to a preauthorization, to indicate whether the benefits payable have been reserved and for whom.
    fundsReserve: ?CodeableConcept = null,
        /// A code for the form to be used for printing the content.
    formCode: ?CodeableConcept = null,
        /// The actual form, by reference or inclusion, for printing the content or an EOB.
    form: ?Attachment = null,
        /// A note that describes or explains adjudication results in a human readable form.
    processNote: ?[] const ClaimResponse_ProcessNote = null,
        /// Request for additional supporting or authorizing information.
    communicationRequest: ?[] const Reference = null,
        /// Financial instruments for reimbursement for the health care products and services specified on the claim.
    insurance: ?[] const ClaimResponse_Insurance = null,
        /// Errors encountered during the processing of the adjudication.
    @"error": ?[] const ClaimResponse_Error = null,

};

    /// Designates which child elements are used to discriminate between the slices when processing an instance. If one or more discriminators are provided, the value of the child elements in the instance data SHALL completely distinguish which slice the element in the resource matches based on the allowed values for those elements in each of the slices.
pub const ElementDefinition_Slicing_Discriminator = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// How the element value is interpreted when discrimination is evaluated.
    @"type": code,
        /// A FHIRPath expression, using [the simple subset of FHIRPath](fhirpath.html#simple), that is used to identify the element on which discrimination is based.
    path: string,

};

    /// Indicates that the element is sliced into a set of alternative definitions (i.e. in a structure definition, there are multiple different constraints on a single element in the base resource). Slicing can be used in any resource that has cardinality ..* on the base resource, or any resource with a choice of types. The set of slices is any elements that come after this in the element sequence that have the same path, until a shorter path occurs (the shorter path terminates the set).
pub const ElementDefinition_Slicing = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// Designates which child elements are used to discriminate between the slices when processing an instance. If one or more discriminators are provided, the value of the child elements in the instance data SHALL completely distinguish which slice the element in the resource matches based on the allowed values for those elements in each of the slices.
    discriminator: ?[] const ElementDefinition_Slicing_Discriminator = null,
        /// A human-readable text description of how the slicing works. If there is no discriminator, this is required to be present to provide whatever information is possible about how the slices can be differentiated.
    description: ?string = null,
        /// If the matching elements have to occur in the same order as defined in the profile.
    ordered: ?boolean = null,
        /// Whether additional slices are allowed or not. When the slices are ordered, profile authors can also say that additional slices are only allowed at the end.
    rules: code,

};

    /// Information about the base definition of the element, provided to make it unnecessary for tools to trace the deviation of the element through the derived and related profiles. When the element definition is not the original definition of an element - i.g. either in a constraint on another type, or for elements from a super type in a snap shot - then the information in provided in the element definition may be different to the base definition. On the original definition of the element, it will be same.
pub const ElementDefinition_Base = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// The Path that identifies the base element - this matches the ElementDefinition.path for that element. Across FHIR, there is only one base definition of any element - that is, an element definition on a [StructureDefinition](structuredefinition.html#) without a StructureDefinition.base.
    path: string,
        /// Minimum cardinality of the base element identified by the path.
    min: unsignedInt,
        /// Maximum cardinality of the base element identified by the path.
    max: string,

};

    /// The data type or resource that the value of this element is permitted to be.
pub const ElementDefinition_Type = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// URL of Data type or Resource that is a(or the) type used for this element. References are URLs that are relative to http://hl7.org/fhir/StructureDefinition e.g. "string" is a reference to http://hl7.org/fhir/StructureDefinition/string. Absolute URLs are only allowed in logical models.
    code: uri,
        /// Identifies a profile structure or implementation Guide that applies to the datatype this element refers to. If any profiles are specified, then the content must conform to at least one of them. The URL can be a local reference - to a contained StructureDefinition, or a reference to another StructureDefinition or Implementation Guide by a canonical URL. When an implementation guide is specified, the type SHALL conform to at least one profile defined in the implementation guide.
    profile: ?[] const canonical = null,
        /// Used when the type is "Reference" or "canonical", and identifies a profile structure or implementation Guide that applies to the target of the reference this element refers to. If any profiles are specified, then the content must conform to at least one of them. The URL can be a local reference - to a contained StructureDefinition, or a reference to another StructureDefinition or Implementation Guide by a canonical URL. When an implementation guide is specified, the target resource SHALL conform to at least one profile defined in the implementation guide.
    targetProfile: ?[] const canonical = null,
        /// If the type is a reference to another resource, how the resource is or can be aggregated - is it a contained resource, or a reference, and if the context is a bundle, is it included in the bundle.
    aggregation: ?[] const code = null,
        /// Whether this reference needs to be version specific or version independent, or whether either can be used.
    versioning: ?code = null,

};

    /// A sample value for this element demonstrating the type of information that would typically be found in the element.
pub const ElementDefinition_Example = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// Describes the purpose of this example amoung the set of examples.
    label: string,
        /// The actual value for the element, which must be one of the types allowed for this element.
    value[x]: unknown,

};

    /// Formal constraints such as co-occurrence and other constraints that can be computationally evaluated within the context of the instance.
pub const ElementDefinition_Constraint = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// Allows identification of which elements have their cardinalities impacted by the constraint.  Will not be referenced for constraints that do not affect cardinality.
    key: id,
        /// Description of why this constraint is necessary or appropriate.
    requirements: ?string = null,
        /// Identifies the impact constraint violation has on the conformance of the instance.
    severity: code,
        /// Text that can be used to describe the constraint in messages identifying that the constraint has been violated.
    human: string,
        /// A [FHIRPath](fhirpath.html) expression of constraint that can be executed to see if this constraint is met.
    expression: ?string = null,
        /// An XPath expression of constraint that can be executed to see if this constraint is met.
    xpath: ?string = null,
        /// A reference to the original source of the constraint, for traceability purposes.
    source: ?canonical = null,

};

    /// Binds to a value set if this element is coded (code, Coding, CodeableConcept, Quantity), or the data types (string, uri).
pub const ElementDefinition_Binding = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// Indicates the degree of conformance expectations associated with this binding - that is, the degree to which the provided value set must be adhered to in the instances.
    strength: code,
        /// Describes the intended use of this particular set of codes.
    description: ?string = null,
        /// Refers to the value set that identifies the set of codes the binding refers to.
    valueSet: ?canonical = null,

};

    /// Identifies a concept from an external specification that roughly corresponds to this element.
pub const ElementDefinition_Mapping = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// An internal reference to the definition of a mapping.
    identity: id,
        /// Identifies the computable language in which mapping.map is expressed.
    language: ?code = null,
        /// Expresses what part of the target specification corresponds to this element.
    map: string,
        /// Comments that provide information about the mapping or its use.
    comment: ?string = null,

};

    /// Base StructureDefinition for ElementDefinition Type: Captures constraints on each element within the resource, profile, or extension.
pub const ElementDefinition = struct {
        /// Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
    id: ?string = null,
        /// May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
    extension: ?[] const Extension = null,
        /// May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
    /// 
    /// Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
    modifierExtension: ?[] const Extension = null,
        /// The path identifies the element and is expressed as a "."-separated list of ancestor elements, beginning with the name of the resource or extension.
    path: string,
        /// Codes that define how this element is represented in instances, when the deviation varies from the normal case.
    representation: ?[] const code = null,
        /// The name of this element definition slice, when slicing is working. The name must be a token with no dots or spaces. This is a unique name referring to a specific set of constraints applied to this element, used to provide a name to different slices of the same element.
    sliceName: ?string = null,
        /// If true, indicates that this slice definition is constraining a slice definition with the same name in an inherited profile. If false, the slice is not overriding any slice in an inherited profile. If missing, the slice might or might not be overriding a slice in an inherited profile, depending on the sliceName.
    sliceIsConstraining: ?boolean = null,
        /// A single preferred label which is the text to display beside the element indicating its meaning or to use to prompt for the element in a user display or form.
    label: ?string = null,
        /// A code that has the same meaning as the element in a particular terminology.
    code: ?[] const Coding = null,
        /// Indicates that the element is sliced into a set of alternative definitions (i.e. in a structure definition, there are multiple different constraints on a single element in the base resource). Slicing can be used in any resource that has cardinality ..* on the base resource, or any resource with a choice of types. The set of slices is any elements that come after this in the element sequence that have the same path, until a shorter path occurs (the shorter path terminates the set).
    slicing: ?ElementDefinition_Slicing = null,
        /// A concise description of what this element means (e.g. for use in autogenerated summaries).
    short: ?string = null,
        /// Provides a complete explanation of the meaning of the data element for human readability.  For the case of elements derived from existing elements (e.g. constraints), the definition SHALL be consistent with the base definition, but convey the meaning of the element in the particular context of use of the resource. (Note: The text you are reading is specified in ElementDefinition.definition).
    definition: ?markdown = null,
        /// Explanatory notes and implementation guidance about the data element, including notes about how to use the data properly, exceptions to proper use, etc. (Note: The text you are reading is specified in ElementDefinition.comment).
    comment: ?markdown = null,
        /// This element is for traceability of why the element was created and why the constraints exist as they do. This may be used to point to source materials or specifications that drove the structure of this element.
    requirements: ?markdown = null,
        /// Identifies additional names by which this element might also be known.
    alias: ?[] const string = null,
        /// The minimum number of times this element SHALL appear in the instance.
    min: ?unsignedInt = null,
        /// The maximum number of times this element is permitted to appear in the instance.
    max: ?string = null,
        /// Information about the base definition of the element, provided to make it unnecessary for tools to trace the deviation of the element through the derived and related profiles. When the element definition is not the original definition of an element - i.g. either in a constraint on another type, or for elements from a super type in a snap shot - then the information in provided in the element definition may be different to the base definition. On the original definition of the element, it will be same.
    base: ?ElementDefinition_Base = null,
        /// Identifies an element defined elsewhere in the definition whose content rules should be applied to the current element. ContentReferences bring across all the rules that are in the ElementDefinition for the element, including definitions, cardinality constraints, bindings, invariants etc.
    contentReference: ?uri = null,
        /// The data type or resource that the value of this element is permitted to be.
    @"type": ?[] const ElementDefinition_Type = null,
        /// The value that should be used if there is no value stated in the instance (e.g. 'if not otherwise specified, the abstract is false').
    defaultValue[x]: ?unknown = null,
        /// The Implicit meaning that is to be understood when this element is missing (e.g. 'when this element is missing, the period is ongoing').
    meaningWhenMissing: ?markdown = null,
        /// If present, indicates that the order of the repeating element has meaning and describes what that meaning is.  If absent, it means that the order of the element has no meaning.
    orderMeaning: ?string = null,
        /// Specifies a value that SHALL be exactly the value  for this element in the instance. For purposes of comparison, non-significant whitespace is ignored, and all values must be an exact match (case and accent sensitive). Missing elements/attributes must also be missing.
    fixed[x]: ?unknown = null,
        /// Specifies a value that the value in the instance SHALL follow - that is, any value in the pattern must be found in the instance. Other additional values may be found too. This is effectively constraint by example.  
    /// 
    /// When pattern[x] is used to constrain a primitive, it means that the value provided in the pattern[x] must match the instance value exactly.
    /// 
    /// When pattern[x] is used to constrain an array, it means that each element provided in the pattern[x] array must (recursively) match at least one element from the instance array.
    /// 
    /// When pattern[x] is used to constrain a complex object, it means that each property in the pattern must be present in the complex object, and its value must recursively match -- i.e.,
    /// 
    /// 1. If primitive: it must match exactly the pattern value
    /// 2. If a complex object: it must match (recursively) the pattern value
    /// 3. If an array: it must match (recursively) the pattern value.
    pattern[x]: ?unknown = null,
        /// A sample value for this element demonstrating the type of information that would typically be found in the element.
    example: ?[] const ElementDefinition_Example = null,
        /// The minimum allowed value for the element. The value is inclusive. This is allowed for the types date, dateTime, instant, time, decimal, integer, and Quantity.
    minValue[x]: ?unknown = null,
        /// The maximum allowed value for the element. The value is inclusive. This is allowed for the types date, dateTime, instant, time, decimal, integer, and Quantity.
    maxValue[x]: ?unknown = null,
        /// Indicates the maximum length in characters that is permitted to be present in conformant instances and which is expected to be supported by conformant consumers that support the element.
    maxLength: ?integer = null,
        /// A reference to an invariant that may make additional statements about the cardinality or value in the instance.
    condition: ?[] const id = null,
        /// Formal constraints such as co-occurrence and other constraints that can be computationally evaluated within the context of the instance.
    constraint: ?[] const ElementDefinition_Constraint = null,
        /// If true, implementations that produce or consume resources SHALL provide "support" for the element in some meaningful way.  If false, the element may be ignored and not supported. If false, whether to populate or use the data element in any way is at the discretion of the implementation.
    mustSupport: ?boolean = null,
        /// If true, the value of this element affects the interpretation of the element or resource that contains it, and the value of the element cannot be ignored. Typically, this is used for status, negation and qualification codes. The effect of this is that the element cannot be ignored by systems: they SHALL either recognize the element and process it, and/or a pre-determination has been made that it is not relevant to their particular system.
    isModifier: ?boolean = null,
        /// Explains how that element affects the interpretation of the resource or element that contains it.
    isModifierReason: ?string = null,
        /// Whether the element should be included if a client requests a search with the parameter _summary=true.
    isSummary: ?boolean = null,
        /// Binds to a value set if this element is coded (code, Coding, CodeableConcept, Quantity), or the data types (string, uri).
    binding: ?ElementDefinition_Binding = null,
        /// Identifies a concept from an external specification that roughly corresponds to this element.
    mapping: ?[] const ElementDefinition_Mapping = null,

};

